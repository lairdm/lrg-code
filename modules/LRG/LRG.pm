use strict;
use warnings;

package LRG;

use XML::Writer;
use IO::File;
use Data::Dumper;
use List::Util qw (min max);

# ROOT OBJECT
#############

package LRG::LRG;

# constructor
sub new {
    my $file = shift if @_;

    my $lrg;
    
    if(defined $file) {
		
		# get an IO object for the file
		my $output = new IO::File(">$file") or die "Could not write to file $file\n";
	
		# initialise the XML::Writer object
		# the last two parameters ensure pretty formatting when the file is written
		$lrg->{'xml'} = new XML::Writer(OUTPUT => $output, DATA_INDENT => 2, DATA_MODE => 1);
	}
	
	else {
		$lrg->{'xml'} = new XML::Writer(DATA_INDENT => 2, DATA_MODE => 1);
	}
    
    # initialise the nodes array
    $lrg->{'nodes'} = ();

    # give this root node a name for completeness' sake
    $lrg->{'name'} = 'LRG_ROOT_NODE';
    
    # bless and return
    bless $lrg, 'LRG::LRG';
    return $lrg;
}

# constructor reads XML from file
sub newFromFile {
    my $file = shift;

    my $outfile = shift if @_;

    # open the file
    open IN, $file or die("Could not read from file $file\n");

    # initiate a blank string to hold the XML
    my $xml_string = '';

    # read in the file
    while(<IN>) {
        chomp;

		# lose leading/trailing whitespace
		s/^\s+//g;
		s/\s+$//g;
	
		# ignore comment lines
		next if /^\<\?/;
	
		$xml_string .= $_;
    }

    close IN;

    my $lrg = LRG::LRG::newFromString($xml_string,$outfile);
    
    return $lrg;
}

sub newFromString {
    my $xml_string = shift;
    my $outfile = shift;
    
    # create a new LRG root - this can be a specific file
    # or just a temporary file if one is not specified
    my $lrg = LRG::LRG::new(defined $outfile ? $outfile : undef);
    
    # Stop here if xml_string is empty
    return $lrg if (!defined($xml_string));
    
    my $current = $lrg;
    my $name;
    
    # get rid of newline and carriage return characters
    $xml_string =~ s/\r+//g;
    $xml_string =~ s/\n+//g;

    my $prev_end = 0;

    # loop through XML tags sequentially
    while($xml_string =~ m/<.+?>/g) {

		# get the matched string and details about it
		my $string = $&;
		my $length = length($string);
		my $pos = pos($xml_string);
		my $start = $pos - $length;
		my $end = $pos;
	
		# this code searches for content between tags
# Changed Will's code because it couldn't handle cases where just a single character was between the tags (e.g. <label>1</label>)
# Make sure nothing breaks because of this!
		if($prev_end >= 1 && $start - $prev_end > 0) {
	
			# get substring from the XML string
			my $temp = substr($xml_string, $prev_end, ($start - $prev_end));
	
			# check that it contains word characters
			if($temp =~ /\w+/) {
				# add content to the current node
				$current->content($temp);
			}
		}	
	
		# reset the prev_end variable
		$prev_end = $end;
	
		# get rid of tag open/close characters
		$string =~ s/\<|\>//g;
		
		my $is_empty;
		$is_empty = 1 if $string =~ /\/$/;
		$string =~ s/\/$//;
	
		# if this is a closing tag, point current to this node's parent
		if($string =~ /^\//) {
			$current = $current->parent;
		}
	
		# otherwise this is an opening or empty tag
        else {

			# split by whitespace
			my @split = split /\s+/, $string;
	
			# the name of the tag is the first element
			$name = shift @split;
	
			# if there are more elements, assume these are additional
			# key/value pairs to be added
			if(scalar @split) {
			
				# join
				$string = join " ", @split;
		
				# change " = " to "="
				$string =~ s/\s*\=\s*/\=/;
		
				# re-split by space or =
				@split = split /\s+|\=/, $string;
				
				my @copy = @split;
				@split = ();
				
				# re-join any values that have been accidentally split
				for(my $i=0; $i<=$#copy; $i++) {
					if($copy[$i] =~ /\'|\"/ and $copy[$i] !~ /\'$|\"$/ and $copy[$i+1] !~ /^\'|^\"/) {
						my $j = $i + 1;
						
						my $val = $copy[$i];
						
						$val .= " ".$copy[$j];
						
						while($copy[$j++] !~ /\'$|\"$/) {
							$val .= " ".$copy[$j];
						}
						
						push @split, $val;
						
						$i = $j - 1;
					}
					
					else {
						push @split, $copy[$i];
					}
				}
		
				# create a new hash
				my %data = ();
		
				# iterate through remaining elements
				while(@split) {
		
					# get key/value pair
					my $key = shift @split;
					my $val = shift @split;
					
          if (!defined $val) {
            print "$key => missing value\n";
            $val = 'nd';
          }

					# remove "s and 's as these are converted to HTML form
					# by XML::Writer
					$val =~ s/\"|\'//g;

					# remove trailing / if it's an empty tag
					$val =~ s/\/$//g;

					# add the data to the hash
					$data{$key} = $val;
				}
		
				# if this is an empty tag (ends with a "/")
				if($is_empty) {
					$current = $current->addEmptyNode($name, \%data);
					
					# reset current to this node's parents
					$current = $current->parent;
				}
		
				# if this is a normal opening tag
				else {
					$current = $current->addNode($name, \%data);
				}
			}
	
			# no extra data elements to add
			else {
			
				# if this is an empty tag (ends with a "/")
				if($is_empty) {
					$current = $current->addEmptyNode($name);
					
					# reset current node to this node's parents
					$current = $current->parent;
				}
		
				# if this is a normal opening tag
				else {
					$current = $current->addNode($name);
				}
			}
        }
    }

    # return
    return $lrg;
}

# add node
sub addNode {
    my $self = shift;

    my $name = shift;
    
    if($name =~ /\//) {
    	return $self->addNodeMulti($name);
    }
    
    # look for an additional arg containing
    # data to be written in the tag itself
    my $data = shift if @_;
    
    # check that the data sent is a hash
    if(scalar keys %{$data}) {
		push @{$self->{'nodes'}}, LRG::Node::new($name, $self->{'xml'}, $data);
    }

    # otherwise assume no data
    else {
		push @{$self->{'nodes'}}, LRG::Node::new($name, $self->{'xml'});
    }

    (@{$self->{'nodes'}})[-1]->{'parent'} = $self;

    # return the last node added (i.e. this one)
    return (@{$self->{'nodes'}})[-1];
}

sub addEmptyNode {
    my $self = shift;

    my $name = shift;
    
    # look for an additional arg containing
    # data to be written in the tag itself
    my $data = shift if @_;
    
    # check that the data sent is a hash
    if(scalar keys %{$data}) {
		push @{$self->{'nodes'}}, LRG::Node::newEmpty($name, $self->{'xml'}, $data);
    }

    # otherwise assume no data
    else {
		push @{$self->{'nodes'}}, LRG::Node::newEmpty($name, $self->{'xml'});
    }

    (@{$self->{'nodes'}})[-1]->{'parent'} = $self;

    # return the last node added (i.e. this one)
    return (@{$self->{'nodes'}})[-1];
}

# add a ready-created node to this node
sub addExisting() {
	my $self = shift;
	
	my $new_node = shift;
	
	$new_node->{'parent'} = $self;
	
	#if(!defined $new_node->xml) {
		$new_node->xml($self->xml) if defined $self->xml;
	#}
	
	# This node is no longer empty
	$self->empty(0);
	
	push @{$self->{'nodes'}}, $new_node;
}

# add multiple embedded nodes
sub addNodeMulti() {
	my $self = shift;
	my $name = shift;

    my @levels = split /\s*\/\s*/, $name;

    # if only one level given, do a normal addNode
    if(scalar @levels == 1) {
		return $self->addNode($name);
    }

    else {
		my $current = $self;
		
		while(@levels) {
			my $level = shift @levels;
	
			if(scalar @levels >= 1) {
				$current = $current->addNode($level);
			}
	
			else {
				return $current->addNode($level);
			}
		}
	}
}

# find node
sub findNode {
    my $self = shift;
    my $name = shift;
    my $data = shift;
    my $no_recursion = shift;


    # do a multi find if the name is delimited with "/"s
    return $self->findNodeMulti($name, $data) if $name =~ /\//;
    
    my $found;
    my $match;
    
    # look through the nodes
    foreach my $node(@{$self->{'nodes'}}) {

		# if the name matches
		if(defined $node->name && defined $name && $node->name eq $name) {
		
			$match = 1;
	
			# if we are comparing data too
			if(scalar keys %$data && scalar keys %{$node->data}) {
				$match = 0;
		
				my $needed = scalar keys %$data;
		
				foreach my $key(keys %$data) {
					next unless defined $node->data->{$key};
		
					$match++ if $node->data->{$key} eq $data->{$key};
				}
		
				$match = ($match == $needed ? 1 : 0);
			}
			
			if($match) {
				$found = $node;
				last;
			}
		}
		
		last if defined $found;
	
		# look recursively in any sub-nodes if not found
		$found = $node->findNode($name, $data) unless ($no_recursion);
    }

    return $found;
}

# find a node among the current node's immediate children (no recursion)
sub findNodeSingle {
    my $self = shift;
    my $name = shift;
    my $data = shift if @_;
    
    return $self->findNode($name,$data,1);
}
# find multiple nodes
sub findNodeArray {
    my $self = shift;
    my $name = shift;
    my $data = shift;
    my $no_recursion = shift;

    # do a multi find if the name is delimited with "/"s
    return $self->findNodeMultiArray($name, $data) if $name =~ /\//;
    
    my @found;
    my $match;
    
    # look through the nodes
    foreach my $node(@{$self->{'nodes'}}) {

		# if the name matches
		if(defined $node->name && defined $name && $node->name eq $name) {
		
			$match = 1;
	
			# if we are comparing data too
			if(scalar keys %$data && scalar keys %{$node->data}) {
				$match = 0;
		
				my $needed = scalar keys %$data;
		
				foreach my $key(keys %$data) {
					next unless defined $node->data->{$key};
		
					$match++ if $node->data->{$key} eq $data->{$key};
				}
		
				$match = ($match == $needed ? 1 : 0);
			}
			
			if($match) {
				push(@found,$node);
			}
		}
			
		# look recursively in any sub-nodes if not found
		unless ($no_recursion) {
		  my $rec = $node->findNodeArray($name, $data);
		  if (defined($rec)) {
		    @found = (@found,@{$rec});
		  }
    }
    }

    return (scalar(@found) > 0 ? \@found : undef);
}

# find multiple nodes among the current node's immediate children (no recursion)
sub findNodeArraySingle {
    my $self = shift;
    my $name = shift;
    my $data = shift if @_;
    
    return $self->findNodeArray($name,$data,1);
}

# find node given multiple levels
sub findNodeMulti {
    my $self = shift;
    my $name = shift;
    my $data = shift;
    my $no_recursion = shift;

    my @levels = split /\s*\/\s*/, $name;

    # if only one level given, do a normal findNode
    if(scalar @levels == 1) {
		return $self->findNode($name, $data, $no_recursion);
    }

    else {
		my $current = $self;
		
		while(@levels && defined($current)) {
			my $level = shift @levels;
	
			if(scalar @levels >= 1) {
				$current = $current->findNode($level, undef, $no_recursion);
			}
	
			else {
				$current = $current->findNode($level, $data, $no_recursion);
			}
		}
	
		return $current;
    }
}

# find node given multiple levels
sub findNodeMultiArray {
    my $self = shift;
    my $name = shift;
    my $data = shift;
    my $no_recursion = shift;

    my @levels = split(/\s*\/\s*/,$name);

    # if only one level given, do a normal findNode
    if(scalar @levels == 1) {
		return $self->findNodeArray($name, $data, $no_recursion);
    }

    else {
		my $current = [$self];
		
		while(@levels && defined($current)) {
			my $level = shift @levels;
			my @nodes;
			if(scalar @levels >= 1) {
			    foreach my $cur (@{$current}) {
				my $arr = $cur->findNodeArray($level, undef, $no_recursion);
				push(@nodes,@{$arr}) if (defined($arr));
			    }
			}
	
			else {
			    foreach my $cur (@{$current}) {
				my $arr = $cur->findNodeArray($level, $data, $no_recursion);
				push(@nodes,@{$arr}) if (defined($arr));
			    }
			}
			$current = \@nodes;
		}
	
		return $current;
    }
}

# find or create a node if it doesn't exist
sub findOrAdd() {
	my $self = shift;
	my $name = shift;
	my $data = shift;
	
	my $find = $self->findNode($name, $data);
	
	if(defined $find) {
		return $find;
	}
	
	else {
		return $self->addNode($name, $data);
	}
}

# compare a node with another
#sub compare {
#	my $self = shift;
#	my $comp = shift;
#	
#	my $match;
#	
#	# if the name matches
#	if(defined $node->name && defined $name && $node->name eq $name) {
#	
#		$match = 1;
#
#		# if we are comparing data too
#		if(scalar keys %$data && scalar keys %{$node->data}) {
#			$match = 0;
#	
#			my $needed = scalar keys %$data;
#	
#			foreach my $key(keys %$data) {
#				next unless defined $node->data->{$key};
#	
#				$match++ if $node->data->{$key} eq $data->{$key};
#			}
#	
#			$match = ($match == $needed ? 1 : 0);
#		}
#		
#		if($match) {
#			$found = $node;
#			last;
#		}
#	}
#}

# print node
sub printNode {
    my $self = shift;
    
	# Attributes - hash for putting key/value pairs in a nice order in the output
	my %priority = (
		
    'align' => {
      'lrg_start' => 1,
      'lrg_end'   => 2,
      'start'     => 3,
      'end'       => 4,
    },
    
    'alternate_amino_acid_numbering' => {
      'description' => 1
    },
    
    'cdna_coords' => {
      'start' => 1,
      'end'   => 2
    },
    
    'coding_region' => {
      'start'       => 1,
      'end'         => 2,
      'codon_start' => 3
    },
    
    'coordinates' => {
      'coord_system' => 1,
      'name'         => 2,
      'start'        => 3,
      'end'          => 4,
      'start_ext'    => 5,
      'end_ext'      => 6,
      'strand'       => 7,
      'mapped_from'  => 8
    },
    
    'db_xref' => {
      'source'    => 1,
      'accession' => 2,
    },
    
    'diff' => {
      'type'        => 1,
      'lrg_start'   => 2,
      'lrg_end'     => 3,
      'other_start' => 4,
      'other_end'   => 5,
      'start' => 4,
      'end'   => 5,
      'lrg_sequence'     => 6,
      'other_sequence'   => 7,
      'genomic_sequence' => 7  # Schema < 1.7
    },
    
    'exon' => {
      'source'    => 1,
      'accession' => 2,
    },
    
    'fixed_transcript_annotation' => {
      'name' => 1
    },
    
    'gene' => {
      'source'    => 1,
      'accession' => 2,
      'symbol'  => 1,
      'strand'  => 2,
      'start'   => 3,
      'end'     => 4
    },
    
    'intron' => {
      'phase' =>  1
    },
    
    'lrg' => {
      'schema_version' => 1
    },
    
    'lrg_coords' => {
      'start' => 1,
      'end'   => 2
    },
    
    'lrg_gene_name' => {
      'source' => 1
    },
    
    'lrg_locus' => {
      'source' => 1
    },
    
		'mapping' => {
		  'coord_system' => 1,
      'other_name'   => 2,
      'other_id'     => 3,
      'other_id_syn' => 4,
      'other_start'  => 5,
      'other_end'    => 6,
      #'assembly'  => 1,
      #'chr_name'  => 2,
      #'chr_id'    => 3,
      #'chr_start' => 4,
      #'chr_end'   => 5,
      'type'      => 7,
		},
		
		'mapping_span' => {
		  'lrg_start'   => 1,
		  'lrg_end'     => 2,
      'other_start' => 3,
      'other_end'   => 4,
      'start' => 3,
      'end'   => 4,
		  'strand'      => 5
		},
		
    'organism' => {
      'taxon' =>  1
    },
    
    'other_exon_naming' => {
      'description' => 1
    },
    
    'peptide_coords' => {
      'start' => 1,
      'end'   => 2
    },
    
    'protein_product' => {
      'source'      => 1,
      'accession'   => 2,
      'cds_start'   => 3,
      'cds_end'     => 4,
      'codon_start' => 5
    },
    
    'pyrrolysine' => {
      'codon' => 1
    },
    
    'selenocysteine' => {
      'codon' => 1
    },
    
    'source' => {
      'description' => 1
    },
    
    'transcript' => {
      'name'          => 1,
      'source'          => 1,
      'start'           => 2,
      'end'             => 3,
      'transcript_id'   => 4,
      'source'    =>  1,
      'accession' =>  2,
      'fixed_id'  =>  5
    },
    
	);

	my @data_array;
	
	# put key/value pairs in a nice order
	if(scalar keys %{$self->data}) {
		
		my @key_order;
		
		# we only need to order when there is more than one set
		my $name = $self->name();
		if(scalar keys %{$self->data} > 1) {
# If the key is not listed in the priority hash, add it with the lowest priority		    
			foreach my $key (keys %{$self->data}) {
			    if (!$priority{$name}{$key}) {
				$priority{$name}{$key} = List::Util::max(values(%{$priority{$name} || {}}),0)+1;
			    }
			}
			
			@key_order = sort {$priority{$name}{$a} <=> $priority{$name}{$b}} keys %{$self->data};
		}
		
		else {
			@key_order =  keys %{$self->data};
		}
		
		# put the data into a hash (key, value, key, value etc.)
		foreach my $key(@key_order) {
			#print $key, " ", $self->data->{$key}, "\n" unless $priority{$key};
			push @data_array, ($key, $self->data->{$key});
		}
		
		#print "\n";
	}
	
    # if this is an empty tag
    # e.g. <mytag data1="value" />
    if($self->empty) {
        if(scalar keys %{$self->data}) {
	    	$self->{'xml'}->emptyTag($self->name, @data_array);#%{$self->data});
		}

		else {
			$self->{'xml'}->emptyTag($self->name);
		}
    }

    # if there is data for this node print like
    # e.g. <mytag data1="value">
    elsif(scalar keys %{$self->data}) {
		$self->{'xml'}->startTag($self->name, @data_array);
    }

    # otherwise just open the bare tag
    # e.g. <mytag>
    else {
		$self->{'xml'}->startTag($self->name);
    }

    if(defined $self->{'content'}) {
		#foreach my $item(@{$node->{'content'}}) {
		$self->{'xml'}->characters($self->content);
		#}
    }

    # Sort the subsequent nodes based on their
    #  1) internal order as specified in the %tag_order hash position, if applicable
    #  2) start and end positions if the tag names are equal and they have start and ens attributes
    my @node_order = sort sort_nodes @{$self->{'nodes'}};
    $self->{'nodes'} = \@node_order;
    
    # recursive iteration
    foreach my $node(@{$self->{'nodes'}}) {
		$node->printNode();
    }

    # end the tag
    $self->{'xml'}->endTag() unless $self->{'empty'};
}

sub sort_nodes {
    
  # If $a or $b are undefined we return 0
  return 0 if (!defined($a) || !defined($b));
 
  # Get the parent node name
  my $parent = $a->parent->name();
  
  # For tags that need to have their elements in a specific order
  my %element_order = (
    'lrg' => {
      'fixed_annotation'     => 1,
      'updatable_annotation' => 2
    },
    
    'fixed_annotation' => {
      'id'            => 1,
      'hgnc_id'       => 2,
      'organism'      => 3,
      'source'        => 4,
      'mol_type'      => 5,
      'creation_date' => 6,
      'comment'       => 7,
      'sequence'      => 8,
      'transcript'    => 9
    },
    
    'transcript' => { # Global (fixed + updatable)
      'creation_date'   => 1,
      'comment'         => 2,
      'coordinates'     => 3,
      'partial'         => 4,
      'long_name'       => 5,
      'db_xref'         => 6,
      'cdna'            => 7,
      'coding_region'   => 8, 
      'exon'            => 9,
      'protein_product' => 10  
    },
    
    'transcript_up' => { # Specific to the updatable section
      'coordinates'     => 1,
      'partial'         => 2,
      'long_name'       => 3,
      'comment'         => 4,
      'db_xref'         => 5,
      'exon'            => 6,
      'protein_product' => 7
    },

    'coding_region' => {
      'coordinates'    => 1,
      'selenocysteine' => 2,
      'pyrrolysine'    => 3,
      'translation'    => 4
    },
    
    'translation' => {
      'sequence' => 1
    },
    
    'exon'  => {
      'coordinates'    => 1,
      'lrg_coords'     => 2,
      'cdna_coords'    => 3,
      'peptide_coords' => 4,
      'partial'        => 5,
      'comment'        => 6,
      'label'          => 7
    },

    'updatable_annotation'  => {
      'annotation_set' => 1
    },
    
    'annotation_set' => {
      'source'  => 1,
      'comment' => 2,
      'modification_date' => 3,
      'fixed_transcript_annotation' => 4,
      'mapping'   => 5,
      'lrg_locus' => 6,
      'features'  => 7,
      'notes'     => 8
    },
    
    'source' => {
      'name'    => 1,
      'url'     => 2,
      'contact' => 3
    },
    
    'contact' => {
      'name'    => 1,
      'url'     => 2,
      'address' => 3,
      'email'   => 4
    },
    
    'fixed_transcript_annotation' => {
      'comment' => 1,
      'other_exon_naming' => 2,
      'alternate_amino_acid_numbering' => 3
    },
    
    'other_exon_naming' => {
      'url'     => 1,
      'comment' => 2,
      'exon'    => 3
    },
    
    'alternate_amino_acid_numbering' => {
      'url'     => 1,
      'comment' => 2,
      'align'   => 3
    },
    
    'mapping' => {
      'mapping_span' => 1
    },
    
    'mapping_span' => {
      'diff' => 1
    },
    
    'features' => {
      'gene' => 1
    },
    
    'gene' => {
      'symbol'      => 1,
      'coordinates' => 2,
      'partial'     => 3,
      'long_name'   => 4,
      'comment'     => 5,
      'db_xref'     => 6,
      'transcript'  => 7
    },
    
    'protein_product' => {
      'coordinates' => 1,
      'partial'     => 2,
      'long_name'   => 3,
      'comment'     => 4,
      'db_xref'     => 5
    },
    
    'db_xref' => {
      'synonym' => 1
    }
  ); 

  # If a and b has the same element name we check if they have start and end attributes to sort them by
  if ($a->name() eq $b->name()) {
	
  	# However, first we need to check if they have a name attribute. If they do, they should be sorted by that instead
	  # (this is to make sure fixed transcripts are sorted according to the order they are specified and not their coordinates)
    if (defined($a->data->{'name'}) && defined($b->data->{'name'})) {
      if ($a->name eq 'transcript') {
        my $a_id = substr($a->data->{'name'},1); # Remove the "t";
        my $b_id = substr($b->data->{'name'},1); # Remove the "t";
        return ($a_id <=> $b_id);
      } else {
        return ($a->data->{'name'} cmp $b->data->{'name'});
      }
    }
    # Sort the updatable genes and transcripts (in the updatable annotation feature) according to their coordinates.
	  if (defined($a->data->{'accession'}) && defined($b->data->{'accession'}) && ($a->name eq 'transcript' or $a->name eq 'gene')) {
      return ($a->findNode('coordinates')->data->{'start'} <=> $b->findNode('coordinates')->data->{'start'});
    }

	  # If not, sort by position if applicable.
    if ((defined($a->data->{'start'}) && defined($b->data->{'start'})) || (defined($a->data->{'lrg_start'}) && defined($b->data->{'lrg_start'}))) {
   
	    my $a_s;
	    my $a_e;
	    my $b_s;
	    my $b_e;
	    
			# Sort by coordinate system (LRG > LRG_t > LRG_p)
			if ($a->name eq 'coordinates') {
				return -1 if ($a->data->{'coord_system'} =~/LRG_\d+$/);
			}
			else {
	    	# Firstly by LRG coords if applicable
	    	if (defined($a->data->{'lrg_start'}) && defined($b->data->{'lrg_start'})) {
	      	$a_s = $a->data->{'lrg_start'};
	      	$a_e = $a->data->{'lrg_end'};
	      	$b_s = $b->data->{'lrg_start'};
	      	$b_e = $b->data->{'lrg_end'};
				}
	    	# Otherwise by general start and end positions
	    	else {
	      	$a_s = $a->data->{'start'};
	      	$a_e = $a->data->{'end'};
	      	$b_s = $b->data->{'start'};
	      	$b_e = $b->data->{'end'};
	    	}
	
	    	# Sort primarily by start and secondarily by end
	    	if ($a_s < $b_s || ($a_s == $b_s && $a_e <= $b_e)) {
	      	return -1;
	    	}
			}

	    return 1;
    }
  }
    
  # If a and b are both in the %element_order hash, order them accordingly. Otherwise do nothing (return 0)
  if (exists($element_order{$parent}->{$a->name()}) && exists($element_order{$parent}->{$b->name()})) {
    # Hacky way to order properly the tags under the "updatable transcript" tags
    my $tr_up_name = 'transcript_up';
    if ($parent eq 'transcript' && $a->parent->parent->name() eq 'gene' && exists($element_order{$tr_up_name}->{$a->name()}) && exists($element_order{$tr_up_name}->{$b->name()})) {
      return ($element_order{$tr_up_name}->{$a->name()} <=> $element_order{$tr_up_name}->{$b->name()}); 
    }
    return ($element_order{$parent}->{$a->name()} <=> $element_order{$parent}->{$b->name()});
  }
    
  return 0;
}

# print all
sub printAll {
    my $self = shift;
		my $no_xsl = shift;
    
    # required to open the XML doc
    $self->{'xml'}->xmlDecl('UTF-8');

    $self->{'xml'}->pi('xml-stylesheet', 'type="application/xml" href="lrg2html.xsl"') if (!defined($no_xsl));
    
    # iterate through the nodes recursively
    foreach my $node(@{$self->{'nodes'}}) {
        $node->printNode();
    }
    
    # finish and write the file
    $self->{'xml'}->end();
}

# getter/setter for name
sub name {
    my $self = shift;

    $self->{'name'} = shift if @_;

    return $self->{'name'};
}

# get parent node
sub parent {
    my $self = shift;

    return $self->{'parent'} if defined $self->{'parent'};
}

# getter/setter for data
sub data {
    my $self = shift;

    $self->{'data'} = shift if @_;

    return $self->{'data'};
}

# add data
sub addData {
	my $self = shift;
	my $new_data = shift;
	
	my %data = %{$self->{'data'}};
	
	foreach my $key(keys %$new_data) {
		$data{$key} = $new_data->{$key};
	}
	
	$self->{'data'} = \%data;
	
	return $self->{'data'};
}

# getter/setter for empty status
sub empty {
    my $self = shift;

    $self->{'empty'} = shift if @_;

    return $self->{'empty'};
}

# getter/setter for content
sub content() {
    my $self = shift;
    
    if (@_) {
      $self->{'content'} = shift;
      $self->empty(0);
    }

    return $self->{'content'};
}

# getter/setter for this node's position in the array order
sub position() {
    my $self = shift;
    my $to = shift if @_;

    # if a new position specified, use the moveTo() subroutine
    $self->moveTo($to) if defined $to;

    my $pos;

    for my $i(0..(scalar @{$self->parent->{'nodes'}} - 1)) {
		if($self eq $self->parent->{'nodes'}->[$i]) {
			$pos = $i;
			last;
		}
    }

    return $pos;
}

# move a node to a specific position in the array
# NB shunts all others down one so any pos need
# to be recalculated
sub moveTo() {
    my $self = shift;
    my $num = (@_ ? shift : 1);
    #$num--;

    my $pos = $self->position();

    # copy the nodes array to @nodes
    my @nodes = @{$self->parent->{'nodes'}};

    # find out the highest index of the array
    my $last_index = $#nodes;
	
	# if num is out of range
	#$num = $last_index + 1 if $num > $last_index + 1;

    # get the before and after arrays:
    # (..@before..)*(..@after..)
    # --------------------------
    # where * is self
    my @before = ($pos - 1 >= 0 ? @nodes[0..($pos-1)] : ());
    my @after = ($pos + 1 <= $last_index ? @nodes[($pos+1)..$last_index] : ());

    # put them back together and recalc the last index
    @nodes = (@before, @after);
    $last_index = $#nodes;

    # chop into two again, only this time get all
    # since this array doesn't include self:
    # (..@before..)(..@after..)
    # -------------------------    
    @before = ($num - 1 >= 0 ? @nodes[0..($num-1)] : ());
    @after = ($num <= $last_index ? @nodes[$num..$last_index] : ());

    # create a new array with self inserted in its new position
    @nodes = (@before, $self, @after);

    # copy the new array into the parent's structure
    $self->parent->{'nodes'} = \@nodes;
}

# count the number of nodes
sub countNodes() {
    my $self = shift @_;

    return scalar @{$self->parent->{'nodes'}};
}

# get content from STDIN given a list of fields
sub requestContent() {
    my $self = shift;
    my $input;
    
    foreach my $item(@_) {
		print "Input $item \>";
		$input = <STDIN>;
		chomp $input;
	
		$self->addNode($item)->content($input);
    }
}

# get current date in a nice format
sub date() {
    my @time = localtime(time());
    
    $time[4]++;

    # add leading zeroes as required
    for my $i(0..4) {
		$time[$i] = "0".$time[$i] if $time[$i] < 10;
    }

    my $time = ($time[5] + 1900)."-".$time[4]."-".$time[3];

    return $time;
}

# getter/recursive setter for the XML object
sub xml() {
	my $self = shift;
	
	my $xml = shift if @_;
	
	if(defined $xml) {
		$self->{'xml'} = $xml;
		
		foreach my $node(@{$self->{'nodes'}}) {
			$node->xml($xml);
		}
	}
	
	return $self->{'xml'};
}

# fetch sequences using pfetch
sub pfetch() {
    my $self = shift;
    my $id = shift;
    my $sequence;

    open IN, "pfetch $id |";
    while(<IN>) {
		next if /^\>/;
		chomp;
		$sequence .= $_;
    }
    close IN;

    return $sequence;
}

# Remove a node
sub remove() {
    my $self = shift;
    my $parent = $self->{'parent'};
    
    for (my $i=0; $i<scalar(@{$parent->{'nodes'}}); $i++) {
	if ($parent->{'nodes'}[$i] == $self) {
	    splice(@{$parent->{'nodes'}},$i,1);
	    last;
	}
    }
}

# Check if this node is identical to the supplied node. The node is identical if everything beneath it is identical
sub identical {
    my $self = shift;
    my $subj = shift;
    
    # If name differs, the nodes are not identical
    if ($self->{'name'} ne $subj->{'name'}) {
	return 0;
    }
    # If content differs, the nodes are not identical
    if ((defined($self->{'content'}) != defined($subj->{'content'})) || (defined($self->{'content'}) && $self->{'content'} ne $subj->{'content'})) {
	return 0;
    }
    # If the number of attributes differs, the nodes are not identical
    if (scalar(keys %{$self->{'data'}}) != scalar(keys %{$subj->{'data'}})) {
	return 0;
    }
    # If the number of child nodes differs, the nodes are not identical
    if (scalar(@{$self->{'nodes'}}) != scalar(@{$subj->{'nodes'}})) {
	return 0;
    }
    # Check that all attributes are identical
    foreach my $key (keys %{$self->{'data'}}) {
	if (!exists($subj->{'data'}{$key}) || $self->{'data'}{$key} ne $subj->{'data'}{$key}) {
	    return 0;
	}
    }
    # Loop over all child nodes and make sure they are identical as well (but allow that they may occur in different order in the child node array)
    foreach my $child (@{$self->{'nodes'}}) {
	my $identical = 0;
	foreach my $subj_child (@{$subj->{'nodes'}}) {
	    $identical = $child->identical($subj_child);
	    if ($identical) {
		last;
	    }
	}
	if (!$identical) {
	    return 0;
	}
    }
    # Now we've checked everything, the nodes must be identical
    return 1;
}

# Check if the supplied node exists among the children of this node. If an optional second argument is supplied, the method will operate recursively on the subtree. The checking is done by the identical() method
sub nodeExists {
    my $self = shift;
    my $subj = shift;
    my $recursion = shift;
    
    foreach my $child (@{$self->{'nodes'}}) {
	if ($child->identical($subj) || (defined($recursion) && $child->nodeExists($subj))) {
	    return 1;
	}
    }
    
    return 0;
}

#�Get an array containing all the nodes in the xml tree (below this one)
sub getAllNodes {
    my $self = shift;
    
    my @arr;
    # Recursively call this function on all child nodes and push the results into the array
    foreach my $child (@{$self->{'nodes'}}) {
	push(@arr,@{$child->getAllNodes()});
    }
    #�Push this node itself into the array and return it
    push(@arr,$self);
    return \@arr;
}

# NODE
######

package LRG::Node;

# inherit some functions from root LRG
our @ISA = "LRG::LRG";

sub new {
    my $name = shift;
	
	if($name =~ /\:\:/) {
		$name = shift;
	}
	
    my $xml = shift if @_;
    
    # look for an additional arg containing
    # data to be written in the tag itself
    my $data = shift if @_;

    my @nodes = ();

    my %node = ();
    my $node_ref = \%node;

    $node{'name'} = $name;
    $node{'nodes'} = \@nodes;
    $node{'xml'} = $xml if defined $xml;
    $node{'data'} = (scalar keys %{$data} ? $data : {});
    $node{'empty'} = 0;

    bless $node_ref, 'LRG::Node';
    return $node_ref;
}

# Create a copy of a node.
# The subtree beneath the source node will be copied recursively so this will be an entirely new subtree
sub newFromNode {
    my $source = shift;
    my $parent = shift;
    
    # If the source node is undefined, this method will return undef as well
    return undef if (!defined($source));
    
    my @nodes = ();
    my %node = ();
    my $node_ref = \%node;
    
    $node{'name'} = $source->{'name'};
    $node{'content'} = $source->{'content'};
    $node{'empty'} = $source->{'empty'};
    $node{'xml'} = $source->{'xml'};
    $node{'parent'} = (defined($parent) ? $parent : $source->{'parent'}); 
    $node{'data'} = {};
    while(my ($key,$value) = each(%{$source->{'data'}})) {
	$node{'data'}->{$key} = $value;
    }
    
    bless $node_ref, 'LRG::Node';
    
    foreach my $source_node (@{$source->{'nodes'}}) {
	push(@nodes,LRG::Node::newFromNode($source_node,$node_ref));
    }
    $node{'nodes'} = \@nodes;
    
    return $node_ref;
}

sub newEmpty {
    my $name = shift;
    my $xml = shift;
    my $data = shift if @_;

    my $node;

    if(scalar keys %{$data}) {
		$node = LRG::Node::new($name, $xml, $data);
    }

    else {
		$node = LRG::Node::new($name, $xml);
    }

    $node->{'empty'} = 1;

    return $node;
}

1;
