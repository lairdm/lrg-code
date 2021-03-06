use strict;
use warnings;

package LRG::API::Base;

use Bio::EnsEMBL::Utils::Scalar;

# Use autoload for get/set methods
our $AUTOLOAD;

sub DESTROY { }

sub new {
  my $class = shift;
  my $self = bless({},$class);
  
  $self->initialize(@_);
  
  return $self;
}

sub dbid {
  my $self = shift;
  my $dbid = shift;
  
  return $self->_get_set('_dbid',$dbid);
}

# Permitted AUTOLOAD routines
sub _permitted {
    return [];
}

# Internal get/set method
sub _get_set {
    my $self = shift;
    my $attribute = shift;
    my $value = shift;
    my $type = shift;
    my $is_array = shift;
    # Use this flag if we need to force the unsetting of a value
    my $force = shift;
    
    if (defined($value)) {
      
      if ($is_array) {
        $value = $self->wrap_array($value);
        if (defined($type)) {
          map { $self->assert_ref($_,$type) } @{$value};
        }
      }
      elsif (defined($type)) {
        $self->assert_ref($value,$type);
      }
      
      $self->{$attribute} = $value;
    }
    elsif ($force) {
      delete($self->{$attribute});
    }
    
    return $self->{$attribute};
}

sub _meta {
  my $self = shift;
  my $key = shift;
  my $value = shift;
  
  # Locate the meta object that contains the key
  my $meta;
  my @keep;
  foreach my $m (@{$self->meta() || []}) {
    unless ($m->key() eq $key) {
      push(@keep,$m);
      next;
    }
    $meta = $m;
  }
  # If we're not updating the value, return what we did or did not find
  return $meta unless (defined($value));
  
  # Update the meta with the pre-existing and the new value

  $self->meta([@keep,LRG::API::Meta->new($key,$value)]);
  #$self->meta([@keep,$value]);

  return $value;
}

sub _add_meta {
  my $self = shift;
  my $key = shift;
  my $value = shift;
  
  return unless (defined($value));

  # Locate the meta object that contains the key
  my @keep;
  foreach my $m (@{$self->meta() || []}) {
    unless ($m->key() eq $key && $m->value() eq $value) {
      push(@keep,$m);
    }
  }
 
  # Update the meta with the new key/value
  $self->meta([@keep,LRG::API::Meta->new($key,$value)]);

  return $value;
}

sub _remove_meta {
  my $self = shift;
  my $key = shift;
  
  # Locate the meta object that contains the key
  my @keep;
  foreach my $m (@{$self->meta() || []}) {
    next if ($m->key() eq $key);
    push(@keep,$m);
  }
  
  # Update the meta with the existing list except the removed metadata
  $self->meta(\@keep);
}

sub AUTOLOAD {
    my $self = shift;
    my $type = ref($self) or die("$self is not an object");

    # The name of the called subroutine
    my $name = $AUTOLOAD;
    # Strip away the pre-pended package info
    $name =~ s/.*://;

    # Check that the subroutine should exist for this module
    unless (grep {/^$name$/} @{$self->_permitted()}) {
        die "Can't access `$name' field in class $type";
    }

    # Call the get/set method
    return $self->_get_set('_' . $name,@_);
}

sub assert_ref {
  shift;
  Bio::EnsEMBL::Utils::Scalar::assert_ref(@_);
}

sub wrap_array {
  shift;
  return Bio::EnsEMBL::Utils::Scalar::wrap_array(@_);
}

# Given a supplied mapping object, if this object contains coordinates, remap the relevant coordinates to the alternative coordinate system described by the mapping
sub remap {
  my $self = shift;
  my $mapping = shift;
	my $destination_coordinate_system = shift;

  return unless (grep {/^coordinates$/} @{$self->_permitted()});
  $self->assert_ref($mapping,'LRG::API::Mapping');

	my @remapped;
	if (defined($destination_coordinate_system)) {
  	@remapped = map {$_->transfer($mapping,$destination_coordinate_system)} @{$self->coordinates() || []};
	}
	else {
		@remapped = map {$_->transfer($mapping)} @{$self->coordinates() || []};
	}
  $self->coordinates([@{$self->coordinates()},@remapped]) if (@remapped);
}

1;
