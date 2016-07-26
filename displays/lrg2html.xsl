<?xml version="1.0" encoding="iso-8859-1"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
   
<xsl:output method="html" encoding="iso-8859-1" indent="yes" doctype-public="-//W3C//DTD HTML 5.0 Transitional//EN"/>

<!-- LRG names -->
<xsl:variable name="lrg_gene_name" select="/lrg/updatable_annotation/annotation_set/lrg_locus"/>
<xsl:variable name="lrg_id" select="/lrg/fixed_annotation/id"/>
<xsl:variable name="lrg_status" select="0"/>

<xsl:variable name="lrg_extra_path">
  <xsl:if test="$lrg_status!=0">../</xsl:if>
</xsl:variable>

<!-- Source names -->
<xsl:variable name="lrg_source_name">LRG</xsl:variable>
<xsl:variable name="ncbi_source_name">NCBI RefSeqGene</xsl:variable>
<xsl:variable name="ensembl_source_name">Ensembl</xsl:variable>
<xsl:variable name="community_source_name">Community</xsl:variable>

<!-- URLs -->
<xsl:variable name="ensembl_root_url">http://www.ensembl.org/Homo_sapiens/</xsl:variable>
<xsl:variable name="ncbi_root_url">http://www.ncbi.nlm.nih.gov/</xsl:variable>
<xsl:variable name="ncbi_url"><xsl:value-of select="$ncbi_root_url"/>nuccore/</xsl:variable>
<xsl:variable name="ncbi_url_map"><xsl:value-of select="$ncbi_root_url"/>mapview/maps.cgi?</xsl:variable>
<xsl:variable name="hgnc_url">http://www.genenames.org/data/hgnc_data.php?hgnc_id=</xsl:variable>
<xsl:variable name="lrg_root_ftp">ftp://ftp.ebi.ac.uk/pub/databases/lrgex/</xsl:variable>
<xsl:variable name="lrg_bed_url"><xsl:value-of select="$lrg_extra_path"/>LRG_GRCh38.bed</xsl:variable>
<xsl:variable name="lrg_diff_url"><xsl:value-of select="$lrg_extra_path"/>LRG_diff_GRCh38.txt</xsl:variable>
<xsl:variable name="lrg_url">http://www.lrg-sequence.org</xsl:variable>
<xsl:variable name="vep_parser_url"><xsl:value-of select="$lrg_url"/>vep_parser?</xsl:variable>
<xsl:variable name="bootstrap_url">https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6</xsl:variable>

<!-- Other general variables -->
<xsl:variable name="lrg_coord_system" select="$lrg_id" />
<xsl:variable name="symbol_source">HGNC</xsl:variable>
<xsl:variable name="previous_assembly">GRCh37</xsl:variable>
<xsl:variable name="current_assembly">GRCh38</xsl:variable>
<xsl:variable name="requester_type">requester</xsl:variable>
<xsl:variable name="new_public_transcript">This transcript was added to the LRG record after it was made public</xsl:variable>
<xsl:variable name="image_width">1000</xsl:variable>

<xsl:decimal-format name="thousands" grouping-separator=","/>

<!-- PATH -->

<xsl:variable name="relative_path">
  <xsl:choose>
    <xsl:when test="$lrg_status!=0">
      <xsl:text>../</xsl:text>
    </xsl:when>
    <xsl:otherwise></xsl:otherwise>
  </xsl:choose>
</xsl:variable>


<xsl:template match="/lrg">

<html lang="en">
  <head>
    <title>Genomic sequence
      <xsl:value-of select="$lrg_id"/> -
      <xsl:value-of select="$lrg_gene_name"/>

      <xsl:if test="$lrg_status=1">
        *** PENDING APPROVAL ***
      </xsl:if>
      <xsl:if test="$lrg_status=2">
        *** STALLED ***
      </xsl:if>
    </title>
    <meta http-equiv="X-UA-Compatible" content="IE=9" />
    <!-- Load the stylesheet and javascript functions -->
    <link rel="stylesheet">
      <xsl:attribute name="href"><xsl:value-of select="$bootstrap_url" />/css/bootstrap.min.css</xsl:attribute>
    </link>
    <link rel="stylesheet">
      <xsl:attribute name="href"><xsl:value-of select="$bootstrap_url" />/css/bootstrap-theme.min.css</xsl:attribute>
    </link>
    
    
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.2/jquery.min.js"></script>
    <xsl:choose>
      <xsl:when test="$lrg_status=0">  
        <link type="text/css" rel="stylesheet" media="all" href="lrg2html.css" />
        <link type="text/css" rel="stylesheet" media="all" href="ebi-visual-custom.css" />
        <script type="text/javascript" src="lrg2html.js" />
        <link rel="icon" type="image/ico" href="img/favicon_public.ico" />
      </xsl:when>
      <xsl:otherwise>
        <link type="text/css" rel="stylesheet" media="all" href="../lrg2html.css" />
        <link type="text/css" rel="stylesheet" media="all" href="../ebi-visual-custom.css" />
        <script type="text/javascript" src="../lrg2html.js" />
        <link rel="icon" type="image/ico" href="../img/favicon_pending.ico" />
      </xsl:otherwise>
    </xsl:choose>
    <script type="text/javascript">
      <xsl:attribute name="src"><xsl:value-of select="$bootstrap_url" />/js/bootstrap.min.js</xsl:attribute>
    </script> 
    <script>
      $(document).ready(function(){
        $('[data-toggle="tooltip"]').tooltip();
        $('button').focus(function() {
          this.blur();
        });
      });
    </script>
  </head>

  <body>
  <xsl:choose>
    <xsl:when test="$lrg_status=0">
      <xsl:attribute name="onload">javascript:search_in_ensembl('<xsl:value-of select="$lrg_id"/>','<xsl:value-of select="$lrg_status"/>');create_external_link('<xsl:value-of select="$lrg_status" />');format_note();</xsl:attribute >
    </xsl:when>
    <xsl:when test="$lrg_status=1">
      <xsl:attribute name="onload">javascript:create_external_link('<xsl:value-of select="$lrg_status" />');format_note();</xsl:attribute >
    </xsl:when>
    <xsl:otherwise>
      <xsl:attribute name="onload">javascript:create_external_link('<xsl:value-of select="$lrg_status" />');</xsl:attribute >
    </xsl:otherwise>
  </xsl:choose>

    <!-- Use the HGNC symbol as header if available -->
    <div class="banner clearfix">
      <div class="banner_left" style="padding:5px 10px">
        <span class="text_header"><xsl:value-of select="$lrg_id"/></span>
        <span class="separator"> </span>
        <span class="text_sub_header"><span class="green_normal">Symbol: </span>
     <xsl:choose>
       <xsl:when test="$lrg_gene_name">
         <xsl:value-of select="$lrg_gene_name"/>
       </xsl:when>
       <xsl:otherwise>
         <xsl:value-of select="updatable_annotation/annotation_set/features/gene/symbol[1]"/>
         <xsl:if test="updatable_annotation/annotation_set/features/gene/long_name">
            : <xsl:value-of select="updatable_annotation/annotation_set/features/gene/long_name"/>
         </xsl:if>
       </xsl:otherwise>
     </xsl:choose>
      </span>
    </div>
    <div class="download_section">
      <div class="download_header icon-download close-icon-5">Download data</div>
      <div class="download_content">
          <xsl:variable name="xml_file_name"><xsl:value-of select="$lrg_id" />.xml</xsl:variable>
          <a class="download_link icon-xml" id="download_xml" data-toggle="tooltip" data-placement="left" title="File containing all the LRG data in a XML file">
            <xsl:attribute name="download"><xsl:value-of select="$xml_file_name"/></xsl:attribute>
            <xsl:attribute name="href"><xsl:value-of select="$xml_file_name"/></xsl:attribute></a>

          <xsl:variable name="fasta_file_name"><xsl:value-of select="$lrg_id" />.fasta</xsl:variable>
          <a  class="download_link icon-fasta close-icon-0" id="download_fasta" data-toggle="tooltip" data-placement="left" title="FASTA file containing the LRG genomic, transcript and protein sequences">
            <xsl:attribute name="download"><xsl:value-of select="$fasta_file_name"/></xsl:attribute>
            <xsl:attribute name="href"><xsl:if test="$lrg_status=1">../</xsl:if>fasta/<xsl:value-of select="$fasta_file_name"/></xsl:attribute></a>
      </div>
    </div>
    <div class="banner_right">
      <a title="Locus Reference Genomic website">
        <xsl:attribute name="href"><xsl:value-of select="$lrg_url"/></xsl:attribute>
        <xsl:call-template name="lrg_logo" />
      </a>
    </div>
  </div>
  
  <!-- Add a banner for non public LRGs -->
  <xsl:choose>
    <xsl:when test="$lrg_status=1">
    <!-- Add a banner indicating that the record is pending if the pending flag is set -->
      <div class="status_banner">
        <div class="pending_title clearfix">
          <div class="status_progress">
            <a title="See the progress status of the curation of this LRG" target="_blank" data-toggle="tooltip" data-placement="bottom">
              <xsl:attribute name="href">../lrgs_progress_status.html#<xsl:value-of select="$lrg_id" /></xsl:attribute >
              <button type="button" class="btn btn-lrg"><span class="icon-next-page smaller-icon close-icon-2"></span>See progress status</button>
            </a>
          </div>
          <div class="status_title icon-alert">PENDING APPROVAL</div>
        </div>
        <div class="status_subtitle pending_subtitle">
          <p>This LRG record is pending approval and subject to change. <b>Please do not use until it has passed final approval</b>. If you are interested in this gene we would like to know what reference sequences you currently use for reporting sequence variants to ensure that this record fulfills the needs of the community. Please e-mail us at <a href="mailto:feedback@lrg-sequence.org">feedback@lrg-sequence.org</a>.</p>
        </div>
      </div>
    </xsl:when>
    <xsl:when test="$lrg_status=2">
      <!-- Add a banner indicating that the record is pending if the pending flag is set -->
      <div class="status_banner">
        <div class="stalled_title">
          <div class="status_title icon-alert">STALLED</div>
        </div>
        <div class="status_subtitle stalled_subtitle">
          <p>
            This LRG record cannot be finalised as it awaits additional information. <b>Please do not use until it has passed final approval</b>. If you have information on this gene, please e-mail us at <a href="mailto:feedback@lrg-sequence.org">feedback@lrg-sequence.org</a>.
          </p>
        </div>
      </div>
    </xsl:when>
  </xsl:choose> 
  <div class="menu_title"> </div>
  
  <!-- Create the menu with within-page navigation -->
  <div class="data_container">
  <div class="menu clearfix">  
    <div class="right_side submenu">
      <h5 class="submenu_section" id="fixed_menu" data-toggle="tooltip" data-placement="left" title="LRG specific data (stable)" >
        <a class="icon-lock" href="#fixed_annotation_anchor">Fixed Annotation</a>
      </h5>
      <ul>
        <li><a href="#genomic_sequence_anchor" class="menu_item" id="genomic_menu" data-toggle="tooltip" data-placement="left" title="LRG genomic sequence, with exons highlighted" >Genomic sequence</a></li>
        <li><a href="#transcripts_anchor" class="menu_item" id="transcript_menu" data-toggle="tooltip" data-placement="left" title="LRG transcript and protein sequences, with exons highlighted">Transcripts</a></li>
      </ul>
      <div class="submenu_section following_section" id="updatable_menu" data-toggle="tooltip" data-placement="left" title="Annotations updated frequently from several sources">
        <a class="icon-unlock" href="#updatable_annotation_anchor">Updatable Annotation</a>
      </div>  
      <ul>
        <li><a href="#set_1_anchor" class="menu_item" id="lrg_menu" data-toggle="tooltip" data-placement="left" title="LRG mapping to the current reference assembly">LRG annotation</a></li>
        <li><a href="#set_2_anchor" class="menu_item" id="ncbi_menu" data-toggle="tooltip" data-placement="left" title="NCBI annotations and LRG mappings to the RefSeqGene transcripts">NCBI annotation</a></li>
        <li><a href="#set_3_anchor" class="menu_item" id="ensembl_menu" data-toggle="tooltip" data-placement="left" title="Ensembl annotations and LRG mappings to the Ensembl transcripts">Ensembl annotation</a></li>
      <xsl:if test="/*/updatable_annotation/annotation_set[source/name=$community_source_name]">
        <li>
          <a href="#set_4_anchor" class="menu_item" id="community_menu" data-toggle="tooltip" data-placement="left">
            <xsl:attribute name="title">Other annotations provided by the gene <xsl:value-of select="$lrg_gene_name"/> community</xsl:attribute>
            Community annotation
          </a>
        </li>
      </xsl:if>
      </ul>
      <div class="submenu_section following_section" id="additional_menu" data-toggle="tooltip" data-placement="left" title="Information about additional annotation sources"> 
        <a class="icon-database-submit" href="#additional_data_anchor">Additional Data Sources</a>
      </div>
      <div class="submenu_section" style="border-bottom:none;padding-top:1px" id="requester_menu" data-toggle="tooltip" data-placement="left" title="Details of the requester(s) of this LRG"> 
        <a class="icon-request" href="#requester_anchor">Requester Information</a>
      </div>
    </div>
    
    <div class="left_side clearfix">
    <div class="section_box">
      <h3 class="section_header icon-info smaller-icon">Summary information</h3>
      <div class="section_content">
      <table>
        <!-- Organism --> 
        <tr><td class="left_col">Organism</td><td class="right_col"><i><xsl:value-of select="fixed_annotation/organism"/></i><span style="padding-left:8px">(<b>Taxon ID: </b><xsl:value-of select="fixed_annotation/organism/@taxon"/>)</span></td></tr>
        <!-- Creation date --> 
        <tr><td class="left_col">Creation date</td><td class="right_col">
          <xsl:call-template name="format_date">
            <xsl:with-param name="date2format"><xsl:value-of select="fixed_annotation/creation_date"/></xsl:with-param>
          </xsl:call-template>
        </td></tr>
      <!-- Molecule type and sequence length -->  
      <xsl:if test="fixed_annotation/hgnc_id">
        <tr><td class="left_col">HGNC identifier</td><td class="right_col" colspan="3">
          <a>
            <xsl:attribute name="class">http_link</xsl:attribute>
            <xsl:attribute name="href"><xsl:value-of select="$hgnc_url" /><xsl:value-of select="fixed_annotation/hgnc_id" /></xsl:attribute>
            <xsl:attribute name="target">_blank</xsl:attribute>
            <xsl:value-of select="fixed_annotation/hgnc_id"/>
          </a> 
          (<b>Symbol: </b><xsl:value-of select="$lrg_gene_name"/>)
        </td></tr>
      </xsl:if> 
       <!-- Molecule type and sequence length -->
        <tr><td class="left_col line_separator">Molecule type</td><td class="right_col line_separator">
          <xsl:value-of select="translate(fixed_annotation/mol_type,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')" />
          <span style="padding-left:8px">(<xsl:value-of select="format-number(string-length(fixed_annotation/sequence),'###,###','thousands')"/> nt)</span>
        </td></tr>
      <!-- RefSeqGene ID -->
      <xsl:if test="fixed_annotation/sequence_source">
        <tr>
          <td class="left_col">Genomic sequence source</td>
          <td class="right_col external_link">Identical to <xsl:value-of select="fixed_annotation/sequence_source"/></td>
        </tr>  
      </xsl:if>
      <!-- Additional information -->
      <xsl:if test="fixed_annotation/comment">
        <tr><td class="left_col" style="color:red">Note</td>
        <td class="right_col external_link"><xsl:value-of select="fixed_annotation/comment"/></td></tr>
      </xsl:if>
      
      <!-- Number of transcripts -->
      <xsl:variable name="count_tr" select="count(fixed_annotation/transcript)" />
        <tr><td class="left_col line_separator">Number of transcript(s)</td><td class="right_col line_separator"><xsl:value-of select="$count_tr" /></td></tr>
      <!-- Transcript names and RefSeqGene transcript names -->
      <xsl:if test="$count_tr!=0">
        <tr><td class="left_col" style="vertical-align:top">Transcript(s) sequence source</td><td class="right_col external_link">
        
        <xsl:for-each select="fixed_annotation/transcript">
          <xsl:if test="position()!=1">
            <br />
          </xsl:if>
          <xsl:variable name="tr_name" select="@name" />
          <xsl:variable name="nm_transcript" select="/*/updatable_annotation/annotation_set[source/name = $ncbi_source_name]/features/gene/transcript[@fixed_id = $tr_name]" />
          <xsl:variable name="ens_transcript" select="/*/updatable_annotation/annotation_set[source/name = $ensembl_source_name]/features/gene/transcript[@fixed_id = $tr_name]" />

          <xsl:choose>
            <xsl:when test="creation_date">
              <span class="new_transcript">
                <xsl:attribute name="title"><xsl:value-of select="$new_public_transcript" /><xsl:text>: </xsl:text>
                  <xsl:call-template name="format_date">
                    <xsl:with-param name="date2format"><xsl:value-of select="creation_date" /></xsl:with-param>
                  </xsl:call-template>
                </xsl:attribute>
                  <xsl:value-of select="$tr_name" />
              </span>
            </xsl:when> 
            <xsl:otherwise>
              <span> 
                <xsl:value-of select="$tr_name" />
              </span>  
            </xsl:otherwise>
          </xsl:choose>
            <xsl:if test="$nm_transcript or $ens_transcript">
              <xsl:text> (</xsl:text>
              <xsl:if test="$nm_transcript">
                <xsl:value-of select="$nm_transcript/@accession" />
              </xsl:if>
              <xsl:if test="$ens_transcript">
                <xsl:if test="$nm_transcript">, </xsl:if>
                <xsl:value-of select="$ens_transcript/@accession" />
              </xsl:if>
              <xsl:text>)</xsl:text>
            </xsl:if>
        </xsl:for-each>
    
        </td></tr>
      </xsl:if>
      </table>
      </div>
    </div>
    <!-- Downloads -->
    <!--<div class="section_box margin_left_20">
      <h3 class="section_header icon-download">Download <xsl:value-of select="$lrg_id" /></h3>
      <div class="section_content" style="text-align:center">
        <div style="margin: 4px 0px">
          <xsl:variable name="xml_file_name"><xsl:value-of select="$lrg_id" />.xml</xsl:variable>
          <a class="green_button" id="download_xml" data-toggle="tooltip" title="File containing all the LRG data in a XML file">
            <xsl:attribute name="download"><xsl:value-of select="$xml_file_name"/></xsl:attribute>
            <xsl:attribute name="href"><xsl:value-of select="$xml_file_name"/></xsl:attribute><button type="button" class="btn btn-lrg">XML format</button></a>
        </div>
        <div style="margin: 4px 0px">
          <xsl:variable name="fasta_file_name"><xsl:value-of select="$lrg_id" />.fasta</xsl:variable>
          <a id="download_fasta" data-toggle="tooltip" title="FASTA file containing the LRG genomic, transcript and protein sequences">
            <xsl:attribute name="download"><xsl:value-of select="$fasta_file_name"/></xsl:attribute>
            <xsl:attribute name="href"><xsl:if test="$lrg_status=1">../</xsl:if>fasta/<xsl:value-of select="$fasta_file_name"/></xsl:attribute><button type="button" class="btn btn-lrg">FASTA format</button></a>
        </div>
        <div class="hidden" id="download_msg"><div style="color:#FFF;padding-top:5px"><small>Right click on the button and then click on "Save target as..." to download the file.</small></div></div>
        </div>
    </div>-->
    
    </div>
  </div>
  
  <!-- FIXED ANNOTATION -->
  <xsl:apply-templates select="fixed_annotation">
    <xsl:with-param name="lrg_id"><xsl:value-of select="$lrg_id" /></xsl:with-param>
  </xsl:apply-templates>
  
  <!-- UPDATABLE ANNOTATION -->
  <xsl:apply-templates select="updatable_annotation">
    <xsl:with-param name="lrg_id"><xsl:value-of select="$lrg_id" /></xsl:with-param>
    <xsl:with-param name="lrg_gene_name"><xsl:value-of select="$lrg_gene_name" /></xsl:with-param>
  </xsl:apply-templates>
  
  <!-- REQUESTER INFORMATION -->
  <xsl:call-template name="requester_information"></xsl:call-template>
  
  <!-- Non LRG public message -->
  <xsl:if test="$lrg_status=1">
    <div class="pending_title">
      <div class="status_title icon-alert">PENDING APPROVAL</div>
    </div>
  </xsl:if>
  <xsl:if test="$lrg_status=2">
    <div class="stalled_title">
      <div class="status_title icon-alert">STALLED</div>
    </div>
  </xsl:if>
  
  </div>
  <xsl:call-template name="footer"/>

    </body>
  </html>
</xsl:template>


<!-- DB XREF -->
<xsl:template match="db_xref">
  
  <strong><xsl:value-of select="@source"/>: </strong>  
  <a>
  <xsl:attribute name="class">icon-external-link</xsl:attribute>
  <xsl:attribute name="target">_blank</xsl:attribute>
  <xsl:choose>
    <xsl:when test="@source='RefSeq'">
      <xsl:attribute name="href">
        <xsl:choose>
          <xsl:when test="contains(@accession,'NP')"><xsl:value-of select="$ncbi_root_url"/>protein/<xsl:value-of select="@accession"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="$ncbi_url"/><xsl:value-of select="@accession"/></xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    </xsl:when>
    <xsl:when test="@source='Ensembl'">
      <xsl:attribute name="href">
        <xsl:choose>
          <xsl:when test="contains(@accession,'ENST')"><xsl:value-of select="$ensembl_root_url"/>Transcript/Summary?db=core;t=<xsl:value-of select="@accession"/></xsl:when>
          <xsl:when test="contains(@accession,'ENSG')"><xsl:value-of select="$ensembl_root_url"/>Gene/Summary?db=core;g=<xsl:value-of select="@accession"/></xsl:when>
          <xsl:when test="contains(@accession,'ENSP')"><xsl:value-of select="$ensembl_root_url"/>Transcript/ProteinSummary?db=core;protein=<xsl:value-of select="@accession"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="$ensembl_root_url"/><xsl:value-of select="@accession"/></xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    </xsl:when>
    <xsl:when test="@source='UniProtKB'">
      <xsl:attribute name="href">http://www.uniprot.org/uniprot/<xsl:value-of select="@accession"/></xsl:attribute>
    </xsl:when>
    <xsl:when test="@source='CCDS'">
      <xsl:attribute name="href"><xsl:value-of select="$ncbi_root_url"/>projects/CCDS/CcdsBrowse.cgi?REQUEST=ALLFIELDS&amp;DATA=<xsl:value-of select="@accession"/></xsl:attribute>
    </xsl:when>
    <xsl:when test="@source='GeneID'">
      <xsl:attribute name="href"><xsl:value-of select="$ncbi_root_url"/>sites/entrez?db=gene&amp;cmd=Retrieve&amp;dopt=Graphics&amp;list_uids=<xsl:value-of select="@accession"/></xsl:attribute>
    </xsl:when>
    <xsl:when test="@source='HGNC'">
      <xsl:attribute name="href"><xsl:value-of select="$hgnc_url" /><xsl:value-of select="@accession"/></xsl:attribute>
    </xsl:when>
    <xsl:when test="@source='MIM'">
      <xsl:attribute name="href"><xsl:value-of select="$ncbi_root_url"/>entrez/dispomim.cgi?id=<xsl:value-of select="@accession"/></xsl:attribute>
    </xsl:when>
    <xsl:when test="@source='GI'">
      <xsl:attribute name="href"><xsl:value-of select="$ncbi_root_url"/>protein/<xsl:value-of select="@accession"/></xsl:attribute>
    </xsl:when>
    <xsl:when test="@source='miRBase'">
      <xsl:attribute name="href">http://www.mirbase.org/cgi-bin/mirna_entry.pl?acc=<xsl:value-of select="@accession"/></xsl:attribute>
    </xsl:when>
    <xsl:when test="@source='RFAM'">
      <xsl:attribute name="href">http://rfam.sanger.ac.uk/family?acc=<xsl:value-of select="@accession"/></xsl:attribute>
    </xsl:when>
  </xsl:choose>
  <!--  Include any optional synonyms as tooltip text for the hyperlink -->
  <xsl:if test="synonym">
    <xsl:attribute name="title">Synonym:<xsl:text> </xsl:text>
      <xsl:for-each select="synonym">
        <xsl:value-of select="." />
        <xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if>
      </xsl:for-each>
    </xsl:attribute>
  </xsl:if>    
  <xsl:value-of select="@accession"/>
  </a>
  
</xsl:template>
   

<!-- SOURCE HEADER -->
<xsl:template name="source_header">
  <xsl:param name="setnum" />
  
  <xsl:variable name="source_name"><xsl:value-of select="source/name"/></xsl:variable>
  <xsl:variable name="source_id">source_<xsl:value-of select="$setnum"/></xsl:variable>
  
  <div class="source">
    <span>
      <xsl:choose>
        <xsl:when test="source/name='LRG'">
          <xsl:attribute name="class">source icon-home</xsl:attribute>
        </xsl:when>
        <xsl:when test="source/name='Community'">
          <xsl:attribute name="class">source icon-group</xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="class">source icon-external-systems</xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
    
      <span class="source_name"><xsl:value-of select="source/name"/> annotation</span></span>
    <xsl:if test="$source_name!='LRG'">
        <button type="button" class="btn btn-lrg show_hide_anno">
          <xsl:attribute name="id">show_hide_anno_<xsl:value-of select="$source_id"/></xsl:attribute>
          <xsl:attribute name="onclick">javascript:showhide_anno('<xsl:value-of select="$source_id"/>');</xsl:attribute>
          <span class="glyphicon glyphicon-plus-sign"></span> Show annotations
        </button>
    </xsl:if>
  </div>
</xsl:template>


<!-- SOURCE -->
<xsl:template match="source">
  <xsl:param name="requester"/>
  <xsl:param name="external"/> 
  <xsl:param name="setnum"/>
  <xsl:param name="use_separator"/>
  <div>
  <xsl:choose>
    <xsl:when test="$requester=1">
      <xsl:if test="name!=''">
        <xsl:attribute name="class">requester_source</xsl:attribute>
        <span class="other_source">Database/Institute: <span class="source_name"><xsl:value-of select="name"/></span></span>
      </xsl:if>
    </xsl:when>
    <xsl:when test="$external=1">
      <xsl:attribute name="class">external_source</xsl:attribute>
    <span class="other_source">Database: <span class="source_name"><xsl:value-of select="name"/></span></span>
    </xsl:when>
    <xsl:otherwise>
      <xsl:attribute name="class">lrg_source</xsl:attribute>
    </xsl:otherwise>
  </xsl:choose>
  
    <div style="margin-top:4px">
      <table>
  <xsl:if test="$requester=1">
    <xsl:attribute name="class">requester_table table_bottom_radius</xsl:attribute>
  </xsl:if>  
    
  <xsl:for-each select="url">
        <tr style="padding-bottom:10px">
          <td class="source_left">
            Website:
          </td>
          <td class="source_right">
    <xsl:call-template name="url">
      <xsl:with-param name="url"><xsl:value-of select="." /></xsl:with-param>
    </xsl:call-template> 
          </td>
        </tr>
  </xsl:for-each>

  <xsl:if test="count(contact)>0">
     
      <xsl:variable name="contact_class">
        <xsl:choose>
          <xsl:when test='contact/address'>contact_lbl_long</xsl:when> 
          <xsl:otherwise>contact_lbl</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

        <tr>
          <td class="source_left">
      <xsl:choose>
        <xsl:when test="count(contact)=1">Contact:</xsl:when>
        <xsl:otherwise>Contacts:</xsl:otherwise>
      </xsl:choose>
          </td>
          <td class="source_right">

      <xsl:for-each select="contact">
        <xsl:if test="position()!=1">
            <div style="height:6px"></div>
        </xsl:if>
            <div>
              <table>
        <xsl:if test="name">
                <tr>
                  <td class="contact_val"><xsl:value-of select="name"/></td>
                </tr>
        </xsl:if>
        <xsl:if test="address">
                <tr>
                  <td class="contact_val"><xsl:value-of select="address"/></td>
                </tr>
        </xsl:if>
        <xsl:if test="email">
                <tr>
                  <td class="contact_val">
                <xsl:call-template name="email" >
                  <xsl:with-param name="c_email"><xsl:value-of select="email"/></xsl:with-param>
                </xsl:call-template>
                  </td>
                </tr>
        </xsl:if>
        <xsl:for-each select="url">
                <tr>
                  <td class="contact_val">              
          <xsl:call-template name="url" >
            <xsl:with-param name="url"><xsl:value-of select="." /></xsl:with-param>
          </xsl:call-template>
                  </td>
                </tr>
        </xsl:for-each>
              </table>
            </div>
      </xsl:for-each>
          </td>
        </tr>
  </xsl:if>
      </table>
    </div>
  </div>
  
  <xsl:if test="$use_separator=1">
  <div class="requester_separator"></div>
  </xsl:if>
</xsl:template>
  

<!-- URL --> 
<xsl:template name="url">
  <xsl:param name="url" />
  <span class="http_link">
    <xsl:if test="not(contains($url, 'http'))">http://</xsl:if>
    <xsl:value-of select="$url"/>
  </span>
</xsl:template>
   

<!-- EMAIL -->
<xsl:template name="email">
  <xsl:param name="c_email" />
  <a>
  <xsl:attribute name="href">
    mailto:<xsl:value-of select="$c_email"/>
  </xsl:attribute>
  <xsl:value-of select="$c_email"/>
  </a>
</xsl:template>


<!-- cds_exon_coords -->
<xsl:template name="cds_exon_coords">
  <xsl:param name="lrg_start"/>
  <xsl:param name="lrg_end"/>
  <xsl:param name="cdna_start"/>
  <xsl:param name="cdna_end"/>
  <xsl:param name="cds_start"/>
  <xsl:param name="cds_end"/>
  <xsl:param name="cds_offset"/>

  <xsl:choose>
    <xsl:when test="$lrg_end &gt; $cds_start and $lrg_start &lt; $cds_end">
  <td>
      <xsl:choose>
        <xsl:when test="$lrg_start &lt; $cds_start">
          <xsl:attribute name="class">partial</xsl:attribute>
  
    <span data-toggle="tooltip" data-placement="bottom">
      <xsl:attribute name="title">UTR: <xsl:value-of select="$cdna_start"/>-<xsl:value-of select="$cds_offset - 1"/> (Transcript)</xsl:attribute>
      <small>(<xsl:value-of select="$cds_offset - $cdna_start"/>bp UTR)</small> 1
    </span>
    
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$cdna_start - $cds_offset + 1"/>
        </xsl:otherwise>
      </xsl:choose>
  </td>
  <td>

      <xsl:choose>
        <xsl:when test="$lrg_end &gt; $cds_end">
          <xsl:attribute name="class">border_separator partial</xsl:attribute>
          
          <xsl:variable name="cds_end_coords" select="($cds_end - $lrg_start) + ($cdna_start - $cds_offset + 1)"/>
          <xsl:variable name="utr_length" select="$lrg_end - $cds_end"/>
          <xsl:variable name="utr_start"  select="$cdna_end - $utr_length + 1"/>
  
          <xsl:value-of select="$cds_end_coords" />
    <span data-toggle="tooltip" data-placement="bottom">
      <xsl:attribute name="title">UTR: <xsl:value-of select="$utr_start"/>-<xsl:value-of select="$cdna_end"/> (Transcript)</xsl:attribute>
      <small> (<xsl:value-of select="$utr_length"/>bp UTR)</small>
    </span>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="class">border_separator</xsl:attribute>
          <xsl:value-of select="$cdna_end - $cds_offset + 1"/>
        </xsl:otherwise>
      </xsl:choose>
  </td>
    </xsl:when>
    <xsl:otherwise>
  <td><span data-toggle="tooltip" data-placement="bottom" title="UTR region">-</span></td>
  <td><span data-toggle="tooltip" data-placement="bottom" title="UTR region">-</span></td>
    </xsl:otherwise>
  </xsl:choose>
     
</xsl:template>
         
<xsl:template xmlns:xslt="http://www.w3.org/1999/XSL/Transform" name="for-loop-d1e144"> 
  <xsl:param name="i"/>
  <xsl:param name="tod1e144"/>
  <xsl:param name="stepd1e144"/>

  <tr>
    <td class="sequence">
  <xsl:value-of select="substring(sequence,$i,60)"/>
    </td>
  </tr>
  <xsl:if test="$i+$stepd1e144 &lt;= $tod1e144">
    <xsl:call-template name="for-loop-d1e144">
      <xsl:with-param name="i" select="$i + $stepd1e144"/>
      <xsl:with-param name="tod1e144" select="$tod1e144"/>
      <xsl:with-param name="stepd1e144" select="$stepd1e144"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>


<!-- for-loop-d1e417 -->
<xsl:template xmlns:xslt="http://www.w3.org/1999/XSL/Transform" name="for-loop-d1e417">
  <xsl:param name="i"/>
  <xsl:param name="tod1e417"/>
  <xsl:param name="stepd1e417"/>
  <xsl:param name="transname"/>
  <xsl:param name="first_exon_start"/>

  <tr>
    <td class="sequence">
  <xsl:value-of select="substring(cdna/sequence,$i,60)"/>
    </td>
  </tr>
  <xsl:if test="$i+$stepd1e417 &lt;= $tod1e417">
    <xsl:call-template name="for-loop-d1e417">
      <xsl:with-param name="i" select="$i + $stepd1e417"/>
      <xsl:with-param name="tod1e417" select="$tod1e417"/>
      <xsl:with-param name="stepd1e417" select="$stepd1e417"/>
      <xsl:with-param name="transname" select="$transname"/>
      <xsl:with-param name="first_exon_start" select="$first_exon_start"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<!-- for-loop-d1e966 -->
<xsl:template xmlns:xslt="http://www.w3.org/1999/XSL/Transform" name="for-loop-d1e966">
  <xsl:param name="i"/>
  <xsl:param name="tod1e966"/>
  <xsl:param name="stepd1e966"/>
  <xsl:param name="transname"/>
  <xsl:param name="first_exon_start"/>

  <tr>
    <td class="sequence">
  <xsl:value-of select="substring(translation/sequence,$i,60)"/>
    </td>
  </tr>
  
  <xsl:if test="$i+$stepd1e966 &lt;= $tod1e966">
    <xsl:call-template name="for-loop-d1e966">
      <xsl:with-param name="i" select="$i + $stepd1e966"/>
      <xsl:with-param name="tod1e966" select="$tod1e966"/>
      <xsl:with-param name="stepd1e966" select="$stepd1e966"/>
      <xsl:with-param name="transname" select="$transname"/>
      <xsl:with-param name="first_exon_start" select="$first_exon_start"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>


<!-- REQUESTER INFORMATION -->
<xsl:template name="requester_information">
<!-- Add a contact section for each requester -->
  <br />
  <div id="requester_div" class="oddDiv">
    <a name="requester_anchor" />
    <div class="section">
      <h2 class="section icon-request">Requester Information</h2>
    </div>
  
  <xsl:for-each select="/lrg/updatable_annotation/annotation_set[@type=$requester_type]/source">
    <xsl:variable name="use_separator">
      <xsl:choose>
        <xsl:when test="position()!=last()">1</xsl:when>
        <xsl:otherwise>0</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="name!=$ncbi_source_name">
      <xsl:apply-templates select=".">         
        <xsl:with-param name="requester">1</xsl:with-param>
        <!--<xsl:if test="position()!=last()">-->
          <xsl:with-param name="use_separator"><xsl:value-of select="$use_separator"/></xsl:with-param>
        <!--</xsl:if>-->
      </xsl:apply-templates>
    </xsl:if>
  </xsl:for-each> 
  </div>
</xsl:template>  

<!-- FIXED ANNOTATION -->
<xsl:template match="fixed_annotation">
  <xsl:param name="lrg_id" />
  <br />
  <div id="fixed_annotation_div" class="oddDiv">
    <a name="fixed_annotation_anchor" />
    <div class="section">
      <h2 class="section icon-lock">Fixed Annotation</h2>
    </div>
    
    <!-- LRG GENOMIC SEQUENCE -->
    <xsl:call-template name="genomic_sequence">
      <xsl:with-param name="lrg_id"><xsl:value-of select="$lrg_id" /></xsl:with-param>
    </xsl:call-template>

    <!-- LRG TRANSCRIPTS -->
    <a name="transcripts_anchor"/>
    <div class="main_subsection">
      <h3 class="main_subsection icon-next-page smaller-icon">Transcript(s)</h3>
    </div>
  
    <!-- Genoverse button -->
    <xsl:variable name="genoverse_div">genoverse_div</xsl:variable>
    
    <div style="margin:5px 5px 10px">
      <button type="button" class="btn btn-lrg" id="show_hide_genoverse_div">
        <xsl:attribute name="onclick">javascript:showhide_genoverse('<xsl:value-of select="$genoverse_div"/>');</xsl:attribute>
        <span class="glyphicon glyphicon-minus-sign"></span> Hide the Genoverse genome browser
      </button>
      <xsl:call-template name="label">
        <xsl:with-param name="label"><xsl:value-of select="$current_assembly"/></xsl:with-param>
        <xsl:with-param name="desc">Data represented on the <xsl:value-of select="$current_assembly"/> assembly</xsl:with-param>
      </xsl:call-template>
    </div>
  
    <!-- Genoverse div -->
    <div class="unhidden">
      <xsl:attribute name="id"><xsl:value-of select="$genoverse_div"/></xsl:attribute>
      
      <div style="position:relative;left:5px">
      
        <div id="genoverse"></div>
        <xsl:variable name="main_mapping" select="/*/updatable_annotation/annotation_set[@type='lrg']/mapping[@type='main_assembly' and contains(@coord_system,$current_assembly)]"/>
        <xsl:variable name="main_chr" select="$main_mapping/@other_name"/>
        <xsl:variable name="main_start" select="$main_mapping/@other_start"/>
        <xsl:variable name="main_end" select="$main_mapping/@other_end"/>
        
        <script type="text/javascript" src="Genoverse/js/genoverse.combined.nojquery.js">
          {
            container : '#genoverse',
            width     : '1100',
            genome    : '<xsl:value-of select="translate($current_assembly,'GRCH','grch')"/>',
            chr       : '<xsl:value-of select="$main_chr"/>',
            start     : <xsl:value-of select="$main_start"/>,
            end       : <xsl:value-of select="$main_end"/>,
            plugins   : [ 'controlPanel', 'karyotype', 'trackControls', 'resizer', 'focusRegion', 'fullscreen', 'tooltips', 'fileDrop' ],
            tracks    : [
              Genoverse.Track.Scalebar,
              Genoverse.Track.extend({
                name       : 'Sequence',
                controller : Genoverse.Track.Controller.Sequence,
                model      : Genoverse.Track.Model.Sequence.Ensembl,
                view       : Genoverse.Track.View.Sequence,
                resizable  : 'auto',
                100000     : false
              }),
              /*Genoverse.Track.Gene.extend({
                disabled : true
              }),
              Genoverse.Track.extend({
                name            : 'Regulatory Features',
                url             : 'http://rest.ensembl.org/overlap/region/human/__CHR__:__START__-__END__?feature=regulatory;content-type=application/json',
                resizable       : 'auto',
                model           : Genoverse.Track.Model.extend({ dataRequestLimit : 5000000 }),
                setFeatureColor : function (f) { f.color = '#AAA'; },
                height        : 0
              }),*/
              Genoverse.Track.File.BED.extend({
                name            : 'LRG',
                url             : '<xsl:value-of select="$lrg_bed_url"/>',
                resizable       : 'auto',
                setFeatureColor : function (f) { f.color = '#090'; }
              }),
              Genoverse.Track.File.DIFF.extend({
                name      : 'LRG diff',
                url       : '<xsl:value-of select="$lrg_diff_url"/>',
                resizable : 'auto'
              })
              /*,
              Genoverse.Track.dbSNP.extend({
                disabled : true
              })*/
            ]
          }
        </script>
      </div>
    </div>
  
  <xsl:for-each select="transcript">
    <xsl:call-template name="lrg_transcript">
      <xsl:with-param name="lrg_id"><xsl:value-of select="$lrg_id" /></xsl:with-param>
    </xsl:call-template>
    <xsl:if test="position()!=last()">
    <div class="lrg_transcript_separator"></div>
    </xsl:if>
  </xsl:for-each>  

   </div>
</xsl:template>
   

<!-- GENOMIC SEQUENCE -->           
<xsl:template name="genomic_sequence">
  <xsl:param name="lrg_id" />
  <!-- Sequence length threshold to avoid errors when the page is loaded with a very large sequence (~2MB) -->
  <xsl:variable name="sequence_max_length">1000000</xsl:variable>      
  <xsl:variable name="transname"><xsl:value-of select="transcript[position() = 1]/@name"/></xsl:variable>

  <a name="genomic_sequence_anchor" />
  <div class="main_subsection clearfix">
    <div style="float:left">
      <h3 class="main_subsection icon-next-page smaller-icon">Genomic sequence</h3>
    </div>
    <div class="show_hide_box" style="margin-top:2px">
      <xsl:call-template name="show_hide_button">
        <xsl:with-param name="div_id">sequence</xsl:with-param>
      </xsl:call-template>
    </div>
  </div>

  <xsl:variable name="fasta_dir">
    <xsl:choose>
      <xsl:when test="$lrg_status=1">../fasta/</xsl:when>
      <xsl:otherwise>fasta/</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <div id="sequence" class="hidden">   
    <div style="float:left;padding:15px 5px 15px"> 
      <table>
        <tr>
          <td width="624" class="sequence">
            <div class="hardbreak">
    <xsl:variable name="genseq" select="sequence"/>
    <xsl:variable name="cdna_coord_system" select="concat($lrg_id,$transname)" />
    <xsl:variable name="pepname"><xsl:value-of select="transcript[@name=$transname]/coding_region[position() = 1]/translation[position() = 1]/@name"/></xsl:variable>
    
    
    <!-- CDS start -->
    <xsl:variable name="cds_start">
      <xsl:call-template name="cds_coordinates">
        <xsl:with-param name="transname"><xsl:value-of select="$transname"/></xsl:with-param>
        <xsl:with-param name="start_end">start</xsl:with-param> 
      </xsl:call-template>
    </xsl:variable>
    <!-- CDS end -->
    <xsl:variable name="cds_end">
      <xsl:call-template name="cds_coordinates">
        <xsl:with-param name="transname"><xsl:value-of select="$transname"/></xsl:with-param>
        <xsl:with-param name="start_end">end</xsl:with-param> 
      </xsl:call-template>
    </xsl:variable>
    
    <!-- Genomic sequence labelling -->
    <xsl:for-each select="transcript[@name=$transname]/exon">
      <xsl:variable name="exon_number" select="position()"/>
      <xsl:variable name="lrg_start"   select="coordinates[@coord_system=$lrg_id]/@start" />
      <xsl:variable name="lrg_end"     select="coordinates[@coord_system=$lrg_id]/@end" />
      <xsl:variable name="cdna_start"  select="coordinates[@coord_system = $cdna_coord_system]/@start" />
      <xsl:variable name="cdna_end"    select="coordinates[@coord_system = $cdna_coord_system]/@end" />

      <xsl:choose>
        <xsl:when test="position()=1">
           <xsl:variable name="upstream_end"><xsl:value-of select="$lrg_start - 1"/></xsl:variable>
              <span class="upstream">
                <xsl:attribute name="title">Upstream sequence 1-<xsl:value-of select="upstream_end"/></xsl:attribute>
                <xsl:value-of select="substring($genseq,1,$upstream_end)"/>
              </span>
             
        </xsl:when>
        <xsl:otherwise>
              <span class="intron">
          <xsl:for-each select="preceding-sibling::*/coordinates[@coord_system=$lrg_id]">
            <xsl:if test="position()=last()">
              <xsl:attribute name="title">Intron <xsl:value-of select="@end + 1"/>-<xsl:value-of select="$lrg_start - 1"/></xsl:attribute>
              <xsl:value-of select="substring($genseq, @end + 1, ($lrg_start - @end) - 1)"/>
            </xsl:if>
          </xsl:for-each>
              </span>
        </xsl:otherwise>
      </xsl:choose>

              <span class="exon_genomic">
                <xsl:attribute name="id">genomic_exon_<xsl:value-of select="$transname"/>_<xsl:value-of select="$exon_number"/></xsl:attribute>
                <xsl:attribute name="onclick">javascript:highlight_exon('<xsl:value-of select="$transname"/>','<xsl:value-of select="$exon_number"/>','<xsl:value-of select="$pepname"/>');</xsl:attribute>
                <xsl:attribute name="title">Exon <xsl:value-of select="$exon_number"/>: <xsl:value-of select="$lrg_start"/>-<xsl:value-of select="$lrg_end"/></xsl:attribute>
                
                <xsl:call-template name="display_exon">
                  <xsl:with-param name="seq"><xsl:value-of select="$genseq"/></xsl:with-param>
                  <xsl:with-param name="lrg_start"><xsl:value-of select="$lrg_start"/></xsl:with-param>
                  <xsl:with-param name="lrg_end"><xsl:value-of select="$lrg_end"/></xsl:with-param>
                  <xsl:with-param name="cds_start"><xsl:value-of select="$cds_start"/></xsl:with-param>
                  <xsl:with-param name="cds_end"><xsl:value-of select="$cds_end"/></xsl:with-param>
                  <xsl:with-param name="seq_start"><xsl:value-of select="$lrg_start"/></xsl:with-param>
                  <xsl:with-param name="seq_end"><xsl:value-of select="$lrg_end"/></xsl:with-param>
                  <xsl:with-param name="utr_class">genomic_utr</xsl:with-param>
                  <xsl:with-param name="transname"><xsl:value-of select="$transname"/></xsl:with-param>
                </xsl:call-template>
              </span>
              
      <xsl:if test="position()=last()">
        <xsl:if test="$lrg_end &lt; string-length($genseq)">
          <xsl:variable name="downstream_start"><xsl:value-of select="$lrg_end + 1"/></xsl:variable>
          <xsl:variable name="downstream_end"><xsl:value-of select="string-length($genseq)"/></xsl:variable>
              <span class="downstream">
                <xsl:attribute name="title">Downstream sequence <xsl:value-of select="$downstream_start"/>-<xsl:value-of select="$downstream_end"/></xsl:attribute>
                <xsl:value-of select="substring($genseq, $downstream_start, $downstream_end - $downstream_start)"/>
              </span>
        </xsl:if>
      </xsl:if>
    </xsl:for-each>
            </div>
          </td>
        </tr>
      <xsl:if test="string-length(/*/fixed_annotation/sequence)&lt;$sequence_max_length">     
        <tr>
          <td class="showhide">
            <xsl:call-template name="hide_button">
              <xsl:with-param name="div_id">sequence</xsl:with-param>
            </xsl:call-template>
          </td>
        </tr>
      </xsl:if>
      </table>
    </div>
     
    <!-- Right handside help/key -->
    <div style="float:left;margin-top:15px;margin-left:20px">
      <div class="seq_info_box">
        <div class="seq_info_header">Information</div>
        <ul class="seq_info">
          <li>
            Only display exons, start codon, stop codon, UTR regions of the 
            <a>
              <xsl:attribute name="style">color:#F00;font-weight:bold</xsl:attribute>
              <xsl:attribute name="href">#transcript_<xsl:value-of select="$transname"/></xsl:attribute>
              LRG transcript <xsl:value-of select="$transname"/>
            </a>
          </li>
          <li>
            Colours help to distinguish the <span class="sequence"><span class="intron">INTRONS</span></span> from the <span class="sequence"><span class="genomic_exon">EXONS</span></span>
          </li>
          <li>
            Colour legend: <span class="sequence"><span class="startcodon sequence_padding">START codon</span> / <span class="stopcodon sequence_padding">STOP codon</span> / <span class="genomic_utr sequence_padding">UTR region</span></span> of the 
            <a>
              <xsl:attribute name="href">#transcript_<xsl:value-of select="$transname"/></xsl:attribute>
              LRG transcript <xsl:value-of select="$transname"/>
            </a>
          </li>
          <li>
            Click on exons to highlight - exons are highlighted in all sequences and exon table.
            <div style="margin-top:5px">
              <button class="btn btn-lrg" type="button">
                 <xsl:attribute name="onclick">javascript:clear_highlight('<xsl:value-of select="$transname"/>');</xsl:attribute>
                 <span class="glyphicon glyphicon glyphicon-chevron-right"></span> Clear all the exon highlightings for the LRG transcript <xsl:value-of select="$transname"/></button>
            </div>
          </li>
        </ul>
      </div>
    <xsl:if test="string-length(/*/fixed_annotation/sequence)&lt;$sequence_max_length">
      <div style="padding-left:5px;margin:10px 0px 15px">
        <xsl:call-template name="right_arrow_green" /> 
        <a>
          <xsl:attribute name="href"><xsl:value-of select="$fasta_dir" /><xsl:value-of select="$lrg_id" />.fasta</xsl:attribute>
          <xsl:attribute name="target">_blank</xsl:attribute>
          Display the genomic, transcript and protein sequences in <b>FASTA</b> format
        </a>
        <small> (in a new tab)</small>
      </div>
    </xsl:if>
    </div>
    <div style="clear:both" />
  </div>
  <br />
</xsl:template>


<!-- LRG TRANSCRIPT -->
<xsl:template name="lrg_transcript">  
  <xsl:param name="lrg_id" />
    
  <xsl:variable name="transname" select="@name"/>
  <xsl:variable name="cdna_coord_system" select="concat($lrg_id,$transname)" />
  <xsl:variable name="pepname" select="coding_region[position() = 1]/translation[position() = 1]/@name" />
  
  <xsl:variable name="peptide_coord_system">
    <xsl:choose>
      <xsl:when test="$pepname"><xsl:value-of select="concat($lrg_id,$pepname)" /></xsl:when>
      <xsl:otherwise><xsl:value-of select="translate($cdna_coord_system,'t','p')" /></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="first_exon_start" select="exon[position() = 1]/coordinates[@coord_system = $lrg_coord_system]/@start"/>
  <xsl:variable name="t_start" select="coordinates[@coord_system = $lrg_coord_system]/@start" />
  <xsl:variable name="t_end" select="coordinates[@coord_system = $lrg_coord_system]/@end" />
  <xsl:variable name="cds_start">
    <xsl:call-template name="cds_coordinates">
      <xsl:with-param name="transname"><xsl:value-of select="$transname" /></xsl:with-param>
      <xsl:with-param name="start_end">start</xsl:with-param> 
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="cds_end">
    <xsl:call-template name="cds_coordinates">
      <xsl:with-param name="transname"><xsl:value-of select="$transname" /></xsl:with-param>
      <xsl:with-param name="start_end">end</xsl:with-param> 
    </xsl:call-template>
  </xsl:variable>
  
    <a>
      <xsl:attribute name="id">transcript_<xsl:value-of select="$transname"/></xsl:attribute>
    </a>
    <div class="lrg_transcript">
      <span class="lrg_transcript">Transcript: 
          <xsl:choose>
            <xsl:when test="creation_date">
              <span class="blue new_transcript" data-toggle="tooltip" data-placement="bottom">
              <xsl:attribute name="title"><xsl:value-of select="$new_public_transcript" /><xsl:text>: </xsl:text>
                <xsl:call-template name="format_date">
                  <xsl:with-param name="date2format"><xsl:value-of select="creation_date" /></xsl:with-param>
                </xsl:call-template>
              </xsl:attribute>
              <xsl:value-of select="$transname"/>
              </span>
            </xsl:when>
            <xsl:otherwise>
              <span class="blue">
              <xsl:value-of select="$transname"/>
              </span>
            </xsl:otherwise>
          </xsl:choose>
      </span>
      <xsl:call-template name="label">
        <xsl:with-param name="label">LRG</xsl:with-param>
        <xsl:with-param name="desc">Coordinates provided in LRG coordinates system</xsl:with-param>
      </xsl:call-template>
    </div>
    
    <table class="lrg_transcript_content">
      <tr>
        <td class="bold_font">Start/end:</td>
        <td><xsl:value-of select="$t_start"/>-<xsl:value-of select="$t_end"/></td>
      </tr>

    <xsl:if test="coding_region/*">
      <tr>
        <td class="bold_font">Coding region:</td>
        <td><xsl:value-of select="$cds_start"/>-<xsl:value-of select="$cds_end"/></td>
      </tr>
    </xsl:if>
    
    <xsl:if test="creation_date">
      <tr>
        <td class="bold_font red">Creation date:</td>
        <td>
          <xsl:call-template name="format_date">
            <xsl:with-param name="date2format"><xsl:value-of select="creation_date" /></xsl:with-param>
          </xsl:call-template>
        </td>
      </tr>
    </xsl:if>

    <!-- get comments and transcript info from the updatable layer-->
    <xsl:for-each select="/*/updatable_annotation/annotation_set">
      <xsl:variable name="setnum" select="position()" />
      <xsl:variable name="setname" select="source[1]/name" />
      <xsl:variable name="comment" select="fixed_transcript_annotation[@name = $transname]/comment" />
      <xsl:if test="$comment">
        <tr>
          <td class="bold_font">Comment:</td>
          <td class="external_link">
            <xsl:value-of select="$comment" />
            <xsl:text> </xsl:text>(comment sourced from <a><xsl:attribute name="href">#set_<xsl:value-of select="$setnum" />_anchor</xsl:attribute><xsl:value-of select="$setname" /></a>)
          </td>
        </tr>
      </xsl:if>
    </xsl:for-each>

    <!-- Display the NCBI/Ensembl accession for the transcript -->
    <xsl:variable name="ref_transcript" select="/*/updatable_annotation/annotation_set[source[1]/name = $ncbi_source_name]/features/gene/transcript[@fixed_id = $transname]" />
    <xsl:variable name="ens_identical_tr" select="/*/updatable_annotation/annotation_set[source[1]/name = $ensembl_source_name]/features/gene/transcript[@fixed_id = $transname]" />
    <xsl:variable name="transcript_comment" select="./comment" />
    <xsl:variable name="translation_exception" select="/*/fixed_annotation/transcript[@name = $transname]/coding_region/translation_exception" />
  
    <xsl:if test="$ref_transcript or $transcript_comment or $ens_identical_tr or $translation_exception or creation_date">
      <tr>
        <td class="bold_font">Comment:</td>
        <td class="external_link">

        <xsl:if test="creation_date">
          <xsl:value-of select="$new_public_transcript" />.
          <br />
        </xsl:if>
      
        <!-- RefSeq transcript -->
        <xsl:if test="$ref_transcript">
          <xsl:variable name="rf_accession"><xsl:value-of select="$ref_transcript/@accession" /></xsl:variable>
          <xsl:if test="not($transcript_comment) or not(contains(comment,$rf_accession))">
            This transcript is identical to the RefSeq transcript <xsl:value-of select="$rf_accession" />.
            <br />
          </xsl:if>
        </xsl:if>

        <!-- Comments from the database or from the NCBI (e.g. polyA) -->
        <xsl:if test="$transcript_comment">
          <xsl:for-each select="./comment">
            <xsl:value-of select="." /><br />
          </xsl:for-each>
        </xsl:if>

        <!-- Ensembl transcript -->
        <xsl:if test="$ens_identical_tr">
          <xsl:variable name="enst_accession"><xsl:value-of select="$ens_identical_tr/@accession" /></xsl:variable>
          <xsl:if test="not($transcript_comment) or not(contains(comment,$enst_accession))">
            This transcript is identical to the Ensembl transcript <xsl:value-of select="$enst_accession" />.
            <br />
          </xsl:if>
        </xsl:if>


        <!-- Updatable annotation -->
        <xsl:if test="$ref_transcript"> 
          <xsl:if test="$ref_transcript/comment">
            <xsl:value-of select="$ref_transcript/comment" />
          </xsl:if>
        </xsl:if>

        <xsl:if test="$translation_exception"> 
          <xsl:if test="$ref_transcript/comment">
          <br />
          </xsl:if>  
          <xsl:for-each select="$translation_exception">
            There is a translation exception for the codon number <b><xsl:value-of select="@codon" /></b> which codes for the amino acid <b><xsl:value-of select="./sequence" /></b>.
            <xsl:if test="position() != last()"><br /></xsl:if>
          </xsl:for-each>
        </xsl:if>
        </td>
      </tr>
    </xsl:if>
  </table>  
  
  <!-- Transcript image -->
  <xsl:call-template name="transcript_image">
    <xsl:with-param name="transname"><xsl:value-of select="$transname" /></xsl:with-param>
    <xsl:with-param name="cdna_coord_system"><xsl:value-of select="$cdna_coord_system" /></xsl:with-param>
  </xsl:call-template>
  

  <!-- cDNA sequence -->
  <xsl:call-template name="lrg_cdna">
    <xsl:with-param name="lrg_id"><xsl:value-of select="$lrg_id" /></xsl:with-param>
    <xsl:with-param name="first_exon_start"><xsl:value-of select="$first_exon_start" /></xsl:with-param>
    <xsl:with-param name="cds_start"><xsl:value-of select="$cds_start" /></xsl:with-param>
    <xsl:with-param name="cds_end"><xsl:value-of select="$cds_end" /></xsl:with-param>
    <xsl:with-param name="transname"><xsl:value-of select="$transname" /></xsl:with-param>
    <xsl:with-param name="cdna_coord_system"><xsl:value-of select="$cdna_coord_system" /></xsl:with-param>
    <xsl:with-param name="peptide_coord_system"><xsl:value-of select="$peptide_coord_system" /></xsl:with-param>
  </xsl:call-template>

  <!-- Exon table -->
  <xsl:call-template name="lrg_exons">
    <xsl:with-param name="lrg_id"><xsl:value-of select="$lrg_id" /></xsl:with-param>
    <xsl:with-param name="transname"><xsl:value-of select="$transname" /></xsl:with-param>
  </xsl:call-template>

  <!-- Translated sequence -->
  <xsl:call-template name="lrg_translation">
    <xsl:with-param name="lrg_id"><xsl:value-of select="$lrg_id" /></xsl:with-param>
    <xsl:with-param name="first_exon_start"><xsl:value-of select="$first_exon_start" /></xsl:with-param>
    <xsl:with-param name="transname"><xsl:value-of select="$transname" /></xsl:with-param>
    <xsl:with-param name="cdna_coord_system"><xsl:value-of select="$cdna_coord_system" /></xsl:with-param>
  </xsl:call-template>

</xsl:template>


<!-- LRG_cDNA -->
<xsl:template name="lrg_cdna"> 
  <xsl:param name="lrg_id" />
  <xsl:param name="first_exon_start" />
  <xsl:param name="cds_start" />
  <xsl:param name="cds_end" />
  <xsl:param name="transname" />
  <xsl:param name="cdna_coord_system" />
  <xsl:param name="peptide_coord_system" />
  <div class="clearfix" style="padding:6px 0px">
    <div class="show_hide_box">
      <xsl:call-template name="show_hide_button">
        <xsl:with-param name="div_id">cdna_<xsl:value-of select="$transname"/></xsl:with-param>
      </xsl:call-template>
    </div>
    <div class="show_hide_box_text">
      <a>
        <xsl:attribute name="id">cdna_sequence_anchor_<xsl:value-of select="$transname"/></xsl:attribute>
      </a>
      <span class="transcript_label">Transcript sequence</span>
    </div>
  </div>
  
  <!-- CDNA SEQUENCE -->
  <div class="hidden">
    <xsl:attribute name="id">cdna_<xsl:value-of select="$transname"/></xsl:attribute>
    
    <div class="unhidden_content">
      <div style="float:left">      
        <table>
          <tr>
            <td width="624" class="sequence">
              <div class="hardbreak">
           <xsl:variable name="seq" select="cdna/sequence"/>
           <xsl:variable name="cstart" select="coding_region[position() = 1]/coordinates/@start"/>
           <xsl:variable name="cend" select="coding_region[position() = 1]/coordinates/@end"/>
           <xsl:variable name="pepname"><xsl:value-of select="coding_region[position() = 1]/translation[position() = 1]/@name"/></xsl:variable>
         
           <xsl:for-each select="exon">
             <xsl:variable name="lrg_start" select="coordinates[@coord_system = $lrg_coord_system]/@start" />
             <xsl:variable name="lrg_end" select="coordinates[@coord_system = $lrg_coord_system]/@end" />
             <xsl:variable name="cdna_start" select="coordinates[@coord_system = $cdna_coord_system]/@start" />
             <xsl:variable name="cdna_end" select="coordinates[@coord_system = $cdna_coord_system]/@end" />
             <xsl:variable name="exon_number" select="position()"/>

                <span>
                  <xsl:attribute name="id">cdna_exon_<xsl:value-of select="$transname"/>_<xsl:value-of select="$exon_number"/></xsl:attribute>
                  <xsl:attribute name="onclick">javascript:highlight_exon('<xsl:value-of select="$transname"/>','<xsl:value-of select="$exon_number"/>','<xsl:value-of select="$pepname"/>');</xsl:attribute>
                  <xsl:attribute name="title">Exon <xsl:value-of select="$exon_number"/> | cDNA: <xsl:value-of select="$cdna_start"/>-<xsl:value-of select="$cdna_end"/> | LRG: <xsl:value-of select="$lrg_start"/>-<xsl:value-of select="$lrg_end"/></xsl:attribute>
    
             <xsl:choose>
               <xsl:when test="round(position() div 2) = (position() div 2)">
                 <xsl:attribute name="class">exon_even</xsl:attribute>
               </xsl:when>
               <xsl:otherwise>
                 <xsl:attribute name="class">exon_odd</xsl:attribute>
               </xsl:otherwise>
             </xsl:choose>
    
             <xsl:call-template name="display_exon">
               <xsl:with-param name="seq"><xsl:value-of select="$seq"/></xsl:with-param>
               <xsl:with-param name="lrg_start"><xsl:value-of select="$lrg_start"/></xsl:with-param>
               <xsl:with-param name="lrg_end"><xsl:value-of select="$lrg_end"/></xsl:with-param>
               <xsl:with-param name="cds_start"><xsl:value-of select="$cds_start"/></xsl:with-param>
               <xsl:with-param name="cds_end"><xsl:value-of select="$cds_end"/></xsl:with-param>
               <xsl:with-param name="seq_start"><xsl:value-of select="$cdna_start"/></xsl:with-param>
               <xsl:with-param name="seq_end"><xsl:value-of select="$cdna_end"/></xsl:with-param>
               <xsl:with-param name="utr_class">utr</xsl:with-param>
               <xsl:with-param name="transname"><xsl:value-of select="$transname"/></xsl:with-param>
             </xsl:call-template>
             
                </span>
          </xsl:for-each>
              </div>
            </td>
          </tr>
  
          <tr>
            <td class="showhide">
              <xsl:call-template name="hide_button">
                <xsl:with-param name="div_id">cdna_<xsl:value-of select="$transname"/></xsl:with-param>
              </xsl:call-template>
            </td>
          </tr>
  
          <tr>
            <td class="showhide">
              <a>
                <xsl:attribute name="id">cdna_fasta_anchor_<xsl:value-of select="$transname"/></xsl:attribute>
              </a>
              <br />
              <div class="clearfix">
                <div class="show_hide_box">
                  <xsl:call-template name="show_hide_button">
                    <xsl:with-param name="div_id">cdna_fasta_<xsl:value-of select="$transname"/></xsl:with-param>
                  </xsl:call-template>
                </div>
                <div class="show_hide_box_text">
                  The transcript sequence <xsl:value-of select="$transname"/> in <b>FASTA</b> format 
                </div>
              </div> 
            </td>
          </tr>
        </table>
      </div>
    
      <!-- Right handside help/key -->
      <div style="float:left;margin-left:20px">
        <div class="seq_info_box">
          <div class="seq_info_header">Information</div>
          <ul class="seq_info">
            <li>
              Colours help to distinguish the different exons, e.g. <span class="sequence"><span class="exon_odd">EXON 1</span> / <span class="exon_even">EXON 2</span></span>
            </li>
            <li>
              <span class="sequence"><span class="startcodon sequence_padding">START codon</span> / <span class="stopcodon sequence_padding">STOP codon</span> / <span class="utr sequence_padding">UTR region</span></span>
            </li>
            <li>
              Click on exons to highlight - exons are highlighted in all sequences and exon table.<br />
              Highlighting helps to distinguish the different exons e.g. <span class="introntableselect sequence_padding">EXON 1</span> / <span class="exontableselect sequence_padding">EXON 2</span>
              <xsl:call-template name="clear_exon_highlights">
                <xsl:with-param name="transname"><xsl:value-of select="$transname"/></xsl:with-param>
              </xsl:call-template>
            </li>
          </ul>
        </div>
        <div style="padding-left:5px;margin:10px 0px 15px">
          <xsl:call-template name="right_arrow_green" />
          <a>
            <xsl:attribute name="href">javascript:show_content('cdna_fasta_<xsl:value-of select="$transname"/>','cdna_fasta_anchor_<xsl:value-of select="$transname"/>');</xsl:attribute>
            Jump to sequence <xsl:value-of select="$transname"/> in <b>FASTA</b> format
          </a>
        </div>
      </div>  
      <div style="clear:both" />
    
    
      <div class="hidden">
        <xsl:attribute name="id">cdna_fasta_<xsl:value-of select="$transname"/></xsl:attribute>
        
        <table border="0" cellpadding="0" cellspacing="0" class="sequence" id="fasta">
      
          <tr>
            <td class="sequence">
              ><xsl:value-of select="$lrg_id"/><xsl:value-of select="$transname"/> (transcript <xsl:value-of select="$transname"/> of <xsl:value-of select="$lrg_id"/>)
            </td>
          </tr>
        
          <xsl:call-template xmlns:xslt="http://www.w3.org/1999/XSL/Transform" name="for-loop-d1e417">
            <xsl:with-param name="i" select="1"/>
            <xsl:with-param name="tod1e417" select="string-length(cdna/sequence)"/>
            <xsl:with-param name="stepd1e417" select="60"/>
            <xsl:with-param name="transname" select="$transname"/>
            <xsl:with-param name="first_exon_start" select="$first_exon_start"/>
          </xsl:call-template>
        </table>
        
        <div style="padding-top:5px">
          <xsl:call-template name="hide_button">
            <xsl:with-param name="div_id">cdna_fasta_<xsl:value-of select="$transname"/></xsl:with-param>
          </xsl:call-template>
        </div>
      
      </div>
    </div>
  </div>
</xsl:template>
    

<!-- LRG EXONS -->
<xsl:template name="lrg_exons"> 
  <xsl:param name="lrg_id" />
  <xsl:param name="transname" />

  <xsl:if test="/*/fixed_annotation/transcript/exon">
    <a>
      <xsl:attribute name="id">exons_<xsl:value-of select="$transname"/></xsl:attribute>
    </a>
    <div class="clearfix" style="padding: 6px 0px">
      <div class="show_hide_box">
        <xsl:call-template name="show_hide_button">
          <xsl:with-param name="div_id">exontable_<xsl:value-of select="$transname"/></xsl:with-param>
        </xsl:call-template>
      </div>
      <div class="show_hide_box_text">
        <a>
          <xsl:attribute name="id">exon_anchor_<xsl:value-of select="$transname"/></xsl:attribute>
        </a>
        <span class="transcript_label">Exons</span> 
      </div>
    </div>    
        
    <!-- EXONS -->
    <xsl:call-template name="exons">
      <xsl:with-param name="exons_id"><xsl:value-of select="$transname" /></xsl:with-param>
      <xsl:with-param name="transname"><xsl:value-of select="$transname" /></xsl:with-param>
      <xsl:with-param name="show_other_exon_naming">0</xsl:with-param>
    </xsl:call-template>
  
  </xsl:if>
</xsl:template>


<!-- LRG_TRANSLATION -->
<xsl:template name="lrg_translation"> 
  <xsl:param name="lrg_id" />
  <xsl:param name="first_exon_start" />
  <xsl:param name="transname" />
  <xsl:param name="cdna_coord_system" />

  <xsl:for-each select="coding_region">
    <xsl:sort select="substring-after(translation/@name,'p')" data-type="number" />

    <xsl:variable name="pepname" select="translation[position() = 1]/@name" />
    <xsl:variable name="peptide_coord_system" select="concat($lrg_id,$pepname)" />

  <div class="clearfix" style="padding: 6px 0px">
    <div class="show_hide_box">
      <xsl:call-template name="show_hide_button">
        <xsl:with-param name="div_id">translated_<xsl:value-of select="$transname"/>_<xsl:value-of select="$pepname"/></xsl:with-param>
      </xsl:call-template>
    </div>
    <div class="show_hide_box_text">
      <a>
        <xsl:attribute name="id">translated_sequence_anchor_<xsl:value-of select="$transname"/>_<xsl:value-of select="$pepname"/></xsl:attribute>
      </a>
      <span class="transcript_label">Translated sequence: <span class="translation_label"><xsl:value-of select="$pepname"/></span></span>
    </div>
  </div> 

  <!-- TRANSLATED SEQUENCE -->
  <div class="hidden">
    <xsl:attribute name="id">translated_<xsl:value-of select="$transname"/>_<xsl:value-of select="$pepname"/></xsl:attribute>

    <div class="unhidden_content">
      <!-- sequence -->
      <div style="float:left"> 
        <table>
           <tr>
             <td width="624" class="sequence">
               <div class="hardbreak">
                 <xsl:variable name="trans_seq" select="translation/sequence"/>
                 <xsl:for-each select="../exon">
                   <xsl:variable name="exon_number" select="position()"/>
                   <xsl:variable name="peptide_start" select="coordinates[@coord_system = $peptide_coord_system]/@start"/>
                   <xsl:variable name="peptide_end" select="coordinates[@coord_system = $peptide_coord_system]/@end"/>

                   <xsl:if test="$peptide_start &lt; string-length($trans_seq)">
                   <span>
                     <xsl:attribute name="id">peptide_exon_<xsl:value-of select="$transname"/>_<xsl:value-of select="$pepname"/>_<xsl:value-of select="$exon_number"/></xsl:attribute>
                     <xsl:attribute name="onclick">javascript:highlight_exon('<xsl:value-of select="$transname"/>','<xsl:value-of select="$exon_number"/>','<xsl:value-of select="$pepname"/>')</xsl:attribute>
                     <xsl:attribute name="title">Exon <xsl:value-of select="$exon_number"/>: <xsl:value-of select="$peptide_start"/>-<xsl:value-of select="$peptide_end"/></xsl:attribute>
                     <xsl:choose>
                       <xsl:when test="round(position() div 2) = (position() div 2)">
                         <xsl:attribute name="class">exon_even</xsl:attribute>
                       </xsl:when>
                       <xsl:otherwise>
                         <xsl:attribute name="class">exon_odd</xsl:attribute>
                       </xsl:otherwise>
                     </xsl:choose>
         
                     <xsl:choose>
                       <xsl:when test="$peptide_start=1">
                         <xsl:choose>
                           <xsl:when test="following-sibling::intron[1]/@phase &gt; 0">
                             <xsl:value-of select="substring($trans_seq,$peptide_start,($peptide_end - $peptide_start))"/>
                           </xsl:when>
                           <xsl:otherwise>
                             <xsl:value-of select="substring($trans_seq,$peptide_start,($peptide_end - $peptide_start) + 1)"/>
                           </xsl:otherwise>
                         </xsl:choose>
                       </xsl:when>
            
                       <xsl:when test="$peptide_end=string-length($trans_seq)">
                         <xsl:choose>
                           <xsl:when test="preceding-sibling::intron[1]/@phase &gt; 0">
                             <xsl:value-of select="substring($trans_seq,$peptide_start + 1,($peptide_end - $peptide_start))"/>
                           </xsl:when>
                           <xsl:otherwise>
                             <xsl:value-of select="substring($trans_seq,$peptide_start,($peptide_end - $peptide_start) + 1)"/>
                           </xsl:otherwise>
                         </xsl:choose>
                       </xsl:when>
            
                       <xsl:otherwise>
                         <xsl:choose>
                           <xsl:when test="preceding-sibling::intron[1]/@phase &gt; 0">
                             <xsl:choose>
                               <xsl:when test="following-sibling::intron[1]/@phase &gt; 0">
                                 <xsl:value-of select="substring($trans_seq,$peptide_start + 1,($peptide_end - $peptide_start) - 1)"/>
                               </xsl:when>
                               <xsl:otherwise>
                                 <xsl:value-of select="substring($trans_seq,$peptide_start + 1,($peptide_end - $peptide_start))"/>
                               </xsl:otherwise>
                             </xsl:choose>
                           </xsl:when>
                           <xsl:otherwise>
                             <xsl:choose>
                               <xsl:when test="following-sibling::intron[1]/@phase &gt; 0">
                                 <xsl:value-of select="substring($trans_seq,$peptide_start,($peptide_end - $peptide_start))"/>
                               </xsl:when>
                               <xsl:otherwise>
                                 <xsl:value-of select="substring($trans_seq,$peptide_start,($peptide_end - $peptide_start) + 1)"/>
                               </xsl:otherwise>
                             </xsl:choose>
                           </xsl:otherwise>
                         </xsl:choose>
                       </xsl:otherwise>
                     </xsl:choose>
                   </span>
                 </xsl:if>
                 <xsl:if test="following-sibling::intron[1]/@phase!=0">
                   <span class="outphase">
                     <xsl:attribute name="title">Intron at <xsl:value-of select="$peptide_end"/> phase <xsl:value-of select="following-sibling::intron[1]/@phase"/></xsl:attribute>
                     <xsl:value-of select="substring($trans_seq,$peptide_end,1)"/>
                   </span>
                 </xsl:if>
               </xsl:for-each>
               </div>
             </td>
           </tr>
      
           <tr>
             <td class="showhide" style="padding-top:10px">
               <xsl:call-template name="hide_button">
                 <xsl:with-param name="div_id">translated_<xsl:value-of select="$transname"/>_<xsl:value-of select="$pepname"/></xsl:with-param>
               </xsl:call-template>
             </td>
           </tr>
           <tr>
             <td class="showhide">
               <a>
                 <xsl:attribute name="id">translated_fasta_anchor_<xsl:value-of select="$transname"/>_<xsl:value-of select="$pepname"/></xsl:attribute>
               </a>
               <br />
               <div>
                <div class="show_hide_box">
                  <xsl:call-template name="show_hide_button">
                    <xsl:with-param name="div_id">translated_fasta_<xsl:value-of select="$transname"/>_<xsl:value-of select="$pepname"/></xsl:with-param>
                  </xsl:call-template>
                </div>
                <div class="show_hide_box_text">
                  The translated sequence <xsl:value-of select="$pepname"/> in <b>FASTA</b> format 
                </div>
                <div style="clear:both"></div>
              </div>
             </td>
           </tr>
         </table>
         
        <div class="hidden">
          <xsl:attribute name="id">translated_fasta_<xsl:value-of select="$transname"/>_<xsl:value-of select="$pepname"/></xsl:attribute>
          <p></p>
          <table border="0" cellpadding="0" cellspacing="0" class="sequence" id="fasta">
             
            <tr>
              <td class="sequence">
                ><xsl:value-of select="$lrg_id"/><xsl:value-of select="$pepname"/> (protein translated from transcript <xsl:value-of select="$transname"/> of <xsl:value-of select="$lrg_id"/>)
              </td>
            </tr>
            <xsl:call-template xmlns:xslt="http://www.w3.org/1999/XSL/Transform" name="for-loop-d1e966">
              <xsl:with-param name="i" select="1"/>
              <xsl:with-param name="tod1e966" select="string-length(translation/sequence)"/>
              <xsl:with-param name="stepd1e966" select="60"/>
              <xsl:with-param name="transname" select="$transname"/>
              <xsl:with-param name="first_exon_start" select="$first_exon_start"/>
            </xsl:call-template>
     
          </table>
           
          <div style="padding:5px 0px">
            <xsl:call-template name="hide_button">
              <xsl:with-param name="div_id">translated_fasta_<xsl:value-of select="$transname"/>_<xsl:value-of select="$pepname"/></xsl:with-param>
            </xsl:call-template>
          </div>
        </div>
      </div>
    
      <!-- Right handside help/key -->
      <div style="float:left;margin-left:20px">
        <div class="seq_info_box">
          <div class="seq_info_header">Information</div>
          <ul class="seq_info">
            <li>
              Colours help to distinguish the different exons e.g. <span class="exon_odd">EXON 1</span> / <span class="exon_even">EXON 2</span>
            </li>
            <li><span class="outphasekey sequence_padding">Shading</span> indicates intron is within the codon for this amino acid</li>    
            <li>
              Click on exons to highlight - exons are highlighted in all sequences and exon table.<br />
              Highlighting helps to distinguish the different exons e.g. <span class="introntableselect sequence_padding">EXON 1</span> / <span class="exontableselect sequence_padding">EXON 2</span>
              <xsl:call-template name="clear_exon_highlights">
                <xsl:with-param name="transname"><xsl:value-of select="$transname"/></xsl:with-param>
              </xsl:call-template>
            </li>
          </ul>
        </div>
      
        <div style="padding-left:5px;margin:10px 0px 15px">
          <xsl:call-template name="right_arrow_green" />
          <a>
            <xsl:attribute name="href">javascript:show_content('translated_fasta_<xsl:value-of select="$transname"/>_<xsl:value-of select="$pepname"/>','translated_fasta_anchor_<xsl:value-of select="$transname"/>_<xsl:value-of select="$pepname"/>');</xsl:attribute>
            Jump to sequence <xsl:value-of select="$pepname"/> in <b>FASTA</b> format
          </a>
        </div>
      </div>
      <div style="clear:both" />
    </div> 
  </div>
  </xsl:for-each>
</xsl:template>


<!-- DISPLAY HILIGHTED EXONS -->
<xsl:template name="display_exon">
  <xsl:param name="seq" />
  <xsl:param name="lrg_start" />
  <xsl:param name="lrg_end" />
  <xsl:param name="cds_start" />
  <xsl:param name="cds_end" />
  <xsl:param name="seq_start" />
  <xsl:param name="seq_end" />
  <xsl:param name="utr_class" />
  <xsl:param name="transname" />

  <xsl:variable name="three_prime_utr_title">3'UTR of <xsl:value-of select="$transname"/></xsl:variable>
  <xsl:variable name="five_prime_utr_title">5'UTR of <xsl:value-of select="$transname"/></xsl:variable>
  <xsl:variable name="start_codon_title">Start codon of <xsl:value-of select="$transname"/></xsl:variable>
  <xsl:variable name="stop_codon_title">Stop codon of <xsl:value-of select="$transname"/></xsl:variable>
  
  <xsl:choose>
    <!-- 5' UTR (complete) -->
    <xsl:when test="$cds_start &gt; $lrg_end">
      <span>
        <xsl:attribute name="class"><xsl:value-of select="$utr_class"/></xsl:attribute>
        <xsl:attribute name="title"><xsl:value-of select="$five_prime_utr_title"/></xsl:attribute>
        <xsl:value-of select="substring($seq,$seq_start,($seq_end - $seq_start) + 1)"/>
      </span>
    </xsl:when>
            
    <!-- 5' UTR (partial) -->
    <xsl:when test="$cds_start &gt; $lrg_start and $cds_start &lt; $lrg_end">
      <span>
        <xsl:attribute name="class"><xsl:value-of select="$utr_class"/></xsl:attribute>
        <xsl:attribute name="title"><xsl:value-of select="$five_prime_utr_title"/></xsl:attribute>
        <xsl:value-of select="substring($seq,$seq_start,($cds_start - $lrg_start))"/>
      </span>
            
      <span class="startcodon">
        <xsl:attribute name="title"><xsl:value-of select="$start_codon_title"/></xsl:attribute>
        <xsl:value-of select="substring($seq,$seq_start + ($cds_start - $lrg_start),3)"/>
      </span>
            
      <!-- We need to handle the special case when start and end codon occur within the same exon -->
      <xsl:choose>
        <xsl:when test="$cds_end &lt; $lrg_end">
          <xsl:variable name="offset_start" select="$seq_start + ($cds_start - $lrg_start)+3"/>
          <xsl:variable name="stop_start" select="($cds_end - $lrg_start) + $seq_start - 2"/>
          <xsl:value-of select="substring($seq,$offset_start,$stop_start - $offset_start)"/>
            
          <span class="stopcodon">
            <xsl:attribute name="title"><xsl:value-of select="$stop_codon_title"/></xsl:attribute>
            <xsl:value-of select="substring($seq,$stop_start,3)"/>
          </span>
            
          <span>
            <xsl:attribute name="class"><xsl:value-of select="$utr_class"/></xsl:attribute>
            <xsl:attribute name="title"><xsl:value-of select="$three_prime_utr_title"/></xsl:attribute>
            <xsl:value-of select="substring($seq,$stop_start + 3,($seq_end - $stop_start - 2))"/>
          </span>
        </xsl:when>
        <xsl:otherwise>
          <xsl:if test="($seq_end - ($seq_start + ($cds_start - $lrg_start))-3+1) &gt; 0">
            <xsl:value-of select="substring($seq,$seq_start + ($cds_start - $lrg_start)+3,$seq_end - ($seq_start + ($cds_start - $lrg_start))-3+1)"/>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
            
    <!-- 3' UTR (partial) -->
    <xsl:when test="$cds_end &gt; $lrg_start and $cds_end &lt; $lrg_end">
      <xsl:value-of select="substring($seq,$seq_start, ($cds_end - $lrg_start)-2)"/>       
      <span class="stopcodon">
        <xsl:attribute name="title"><xsl:value-of select="$stop_codon_title"/></xsl:attribute>
        <xsl:value-of select="substring($seq,($cds_end - $lrg_start) + $seq_start - 2,3)"/>
      </span>
      <span>
        <xsl:attribute name="class"><xsl:value-of select="$utr_class"/></xsl:attribute>
        <xsl:attribute name="title"><xsl:value-of select="$three_prime_utr_title"/></xsl:attribute>
        <xsl:value-of select="substring($seq,($cds_end - $lrg_start) + $seq_start + 1, ($seq_end - (($cds_end - $lrg_start) + $seq_start)))"/>
      </span>
    </xsl:when>
        
    <!-- 3' UTR (complete) -->
    <xsl:when test="$cds_end &lt; $lrg_start">
      <span>
        <xsl:attribute name="class"><xsl:value-of select="$utr_class"/></xsl:attribute>
        <xsl:attribute name="title"><xsl:value-of select="$three_prime_utr_title"/></xsl:attribute>
        <xsl:value-of select="substring($seq,$seq_start,($seq_end - $seq_start) + 1)"/>
      </span>
    </xsl:when>
            
    <!-- neither UTR -->
    <xsl:otherwise>
      <xsl:value-of select="substring($seq,$seq_start,($seq_end - $seq_start) + 1)"/>
    </xsl:otherwise>
            
  </xsl:choose>
</xsl:template>


<!-- UPDATABLE ANNOTATION -->
<xsl:template match="updatable_annotation">
  <xsl:param name="lrg_id" />
  <xsl:param name="lrg_gene_name" />
  <div id="updatable_annotation_div" class="evenDiv">

    <a name="updatable_annotation_anchor" />
    <div class="section">
      <h2 class="section icon-unlock">Updatable Annotation</h2>
    </div>
   
  <xsl:for-each select="annotation_set[source/name=$lrg_source_name or source/name=$ncbi_source_name or source/name=$ensembl_source_name or source/name=$community_source_name] ">
    <div class="meta_source">
      <xsl:apply-templates select=".">
        <xsl:with-param name="lrg_id"><xsl:value-of select="$lrg_id" /></xsl:with-param>
        <xsl:with-param name="setnum" select="position()" />
      </xsl:apply-templates>
    </div>
  </xsl:for-each>
  
  </div>
  
  <!-- Add the additional LSDB data -->
  <div id="additional_data_div" class="evenDiv">
    <a name="additional_data_anchor" />
    <div class="section" style="margin-bottom:0px">
      <h2 class="section icon-database-submit">Additional Data Sources for <xsl:value-of select="$lrg_gene_name"/></h2>
    </div>
    <br />

    <xsl:variable name="lsdb_list">List of locus specific databases for <xsl:value-of select="$lrg_gene_name"/></xsl:variable>
    <xsl:variable name="lsdb_url">http://<xsl:value-of select="$lrg_gene_name"/>.lovd.nl</xsl:variable>

    <div style="margin-top:10px">
      <xsl:attribute name="class">external_source</xsl:attribute>
      <div class="other_source"><span class="other_source"><xsl:value-of select="$lsdb_list"/></span></div>
      <span style="font-weight:bold;padding-left:5px">Website: </span>
    <xsl:choose>
    <xsl:when test="annotation_set[source/name!=$lsdb_list]">
      <xsl:call-template name="url">
        <xsl:with-param name="url"><xsl:value-of select="$lsdb_url" /></xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:for-each select="annotation_set[source/name=$lsdb_list]">
        <xsl:call-template name="url">
          <xsl:with-param name="url"><xsl:value-of select="source/url" /></xsl:with-param>
        </xsl:call-template>
      </xsl:for-each>
    </xsl:otherwise>
    </xsl:choose>
    </div>
  </div>
</xsl:template> 
 

<!-- ANNOTATION SET -->
<xsl:template match="annotation_set">
  <xsl:param name="lrg_id" />
  <xsl:param name="setnum" />

  <a>
  <xsl:attribute name="id">set_<xsl:value-of select="$setnum"/>_anchor</xsl:attribute>
  </a>
  
  <xsl:call-template name="source_header">
    <xsl:with-param name="setnum"><xsl:value-of select="$setnum"/></xsl:with-param>
  </xsl:call-template>
  
  <div style="margin-bottom:50px">
  <xsl:if test="source/name!='LRG'">
    <xsl:attribute name="class">hidden</xsl:attribute>
    <xsl:attribute name="id">source_<xsl:value-of select="$setnum"/></xsl:attribute>
    
    <xsl:apply-templates select="source" />
  </xsl:if>  
  
  <xsl:if test="source/name=$ensembl_source_name">
    <div id="ensembl_links"></div>
  </xsl:if>

    <p class="external_link" style="padding-left:5px">
      <xsl:if test="modification_date">
        <span class="line_header">Modification date:</span>
        <xsl:call-template name="format_date">
          <xsl:with-param name="date2format"><xsl:value-of select="modification_date"/></xsl:with-param>
        </xsl:call-template>
      </xsl:if>
      <xsl:if test="comment">
        <br/>
        <span class="line_header">Comment:</span><xsl:value-of select="comment" />
      </xsl:if>
      <xsl:if test="note">
        <div>
          <div class="float_left">
            <span class="line_header">Note:</span>
          </div>
          <div class="float_left note_content">
            <xsl:value-of select="note"/>
            <xsl:if test="note/@author"> (<xsl:value-of select="note/@author"/>)</xsl:if>
          </div>
          <div style="clear:both"></div>
        </div>
      </xsl:if>
    </p>
   
    <!-- Other exon naming, alternative amino acid naming, comment -->  
    <div>
      <xsl:attribute name="id">
        <xsl:text>fixed_transcript_annotation_set_</xsl:text><xsl:value-of select="$setnum" />
      </xsl:attribute>

      <div style="margin-left:-5px">
        <xsl:attribute name="class"><xsl:text>fixed_transcript_annotation</xsl:text></xsl:attribute>
        <xsl:attribute name="id"><xsl:text>fixed_transcript_annotation_comment_set_</xsl:text><xsl:value-of select="$setnum" /></xsl:attribute>
        <xsl:if test="fixed_transcript_annotation/comment/*">
          <h3>Comment</h3>
          <xsl:for-each select="fixed_transcript_annotation/comment">
            <xsl:call-template name="comment">
              <xsl:with-param name="lrg_id" select="$lrg_id" />
              <xsl:with-param name="transname" select="../@name" />
              <xsl:with-param name="setnum" select="$setnum" />
            </xsl:call-template>
          </xsl:for-each>
        </xsl:if>
      </div>

      <div style="margin-left:-5px">
        <xsl:attribute name="class"><xsl:text>fixed_transcript_annotation</xsl:text></xsl:attribute>
        <xsl:attribute name="id"><xsl:text>fixed_transcript_annotation_aa_set_</xsl:text><xsl:value-of select="$setnum" /></xsl:attribute>
        <xsl:if test="fixed_transcript_annotation/other_exon_naming/*">
          <h3 class="subsection icon-next-page smaller-icon">Additional exon numbering</h3>
          <xsl:for-each select="fixed_transcript_annotation">
            <xsl:if test="other_exon_naming/*">
              <xsl:call-template name="additional_exon_numbering">
                <xsl:with-param name="lrg_id" select="$lrg_id" />
                <xsl:with-param name="transname" select="@name" />
                <xsl:with-param name="setnum" select="$setnum" />
              </xsl:call-template>
            </xsl:if>
          </xsl:for-each>
          <br />
        </xsl:if>
      </div>
    
      <div>
        <xsl:attribute name="class"><xsl:text>fixed_transcript_annotation</xsl:text></xsl:attribute>
        <xsl:attribute name="id"><xsl:text>fixed_transcript_annotation_aa_set_</xsl:text><xsl:value-of select="$setnum" /></xsl:attribute>
        <xsl:if test="fixed_transcript_annotation/alternate_amino_acid_numbering/*">
          <h3 class="subsection icon-next-page smaller-icon">Additional amino acid numbering</h3>
          <xsl:for-each select="fixed_transcript_annotation/alternate_amino_acid_numbering">
            <xsl:apply-templates select=".">
              <xsl:with-param name="lrg_id" select="$lrg_id" />
              <xsl:with-param name="transname" select="../@name" />
              <xsl:with-param name="setnum" select="$setnum" />
            </xsl:apply-templates>
          </xsl:for-each>
          <br />
        </xsl:if>
      </div>  
    </div> 
  
    <!-- Display the annotated features -->
    <xsl:if test="features/*">
      <xsl:apply-templates select="features">
        <xsl:with-param name="lrg_id"><xsl:value-of select="$lrg_id" /></xsl:with-param>
        <xsl:with-param name="setnum"><xsl:value-of select="$setnum" /></xsl:with-param>
      </xsl:apply-templates>
    </xsl:if>

    <!-- Insert the genomic mapping tables -->
    <xsl:choose>
      <xsl:when test="source/name='LRG'">
         <!-- Assembly(ies) -->    
        <xsl:for-each select="mapping[@type='main_assembly' or @type='other_assembly']">
          <xsl:sort select="@type" data-type="text"/>
          <xsl:sort select="@other_name" data-type="text"/>
          <xsl:call-template name="g_mapping">
            <xsl:with-param name="lrg_id"><xsl:value-of select="$lrg_id" /></xsl:with-param>
          </xsl:call-template>
        </xsl:for-each>
        
        <!-- Haplotype(s) -->
        <xsl:variable name="haplotypes" select="mapping[@type='haplotype']" />
        <xsl:if test="count($haplotypes)>0">
          <div class="main_subsection">
            <div style="float:left">
              <h3 class="main_subsection">Mapping(s) to <xsl:value-of select="count($haplotypes)"/> haplotype(s)</h3>
            </div>
            <div class="show_hide_box" style="margin-top:2px">
              <xsl:call-template name="show_hide_button">
                <xsl:with-param name="div_id">haplo_mappings</xsl:with-param>
              </xsl:call-template>
            </div>
            <div style="clear:both"></div>
          </div>
          <div style="margin:0px 10px">  
            <div id="haplo_mappings" class="hidden"> 
            <!--<xsl:for-each select="mapping[@other_name='unlocalized']">-->
            <xsl:for-each select="$haplotypes">
              <xsl:sort select="@coord_system" data-type="text"/>
              <xsl:sort select="@other_name" data-type="text"/>
              <xsl:call-template name="g_mapping">
                <xsl:with-param name="lrg_id"><xsl:value-of select="$lrg_id" /></xsl:with-param>
              </xsl:call-template>
            </xsl:for-each>
            </div>
          </div>
        </xsl:if>
        
        <!-- Patch(es) -->
        <xsl:variable name="patches" select="mapping[@type='patch']" />
        <xsl:if test="count($patches)>0">
          <div class="main_subsection">
            <div style="float:left">
              <h3 class="main_subsection">Mapping(s) to <xsl:value-of select="count($patches)"/> patch(es)</h3>
            </div>
            <div class="show_hide_box" style="margin-top:2px">
              <xsl:call-template name="show_hide_button">
                <xsl:with-param name="div_id">patch_mappings</xsl:with-param>
              </xsl:call-template>
            </div>
            <div style="clear:both"></div>
          </div>
          <div style="margin:0px 10px">  
            <div id="patch_mappings" class="hidden"> 
            <xsl:for-each select="$patches">
              <xsl:sort select="@coord_system" data-type="text"/>
              <xsl:sort select="@other_name" data-type="text"/>
              <xsl:call-template name="g_mapping">
                <xsl:with-param name="lrg_id"><xsl:value-of select="$lrg_id" /></xsl:with-param>
              </xsl:call-template>
            </xsl:for-each>
            </div>
          </div>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <div class="top_upd_anno_link">
          <a>
            <xsl:attribute name="href">#set_<xsl:value-of select="$setnum" />_anchor</xsl:attribute>
            [Back to the top of the <b><xsl:value-of select="source/name" /></b> annotation]
          </a>
        </div>
      </xsl:otherwise>
    </xsl:choose>
    
  </div>
</xsl:template>


<!-- GENOMIC MAPPING -->
<xsl:template name="g_mapping">
  <xsl:param name="lrg_id" />
  
  <xsl:variable name="coord_system"  select="@coord_system" />
  <xsl:variable name="region_name"   select="@other_name" />
  <xsl:variable name="region_id"     select="@other_id" />
  <xsl:variable name="region_id_syn" select="@other_id_syn" />
  <xsl:variable name="region_start"  select="@other_start" />
  <xsl:variable name="region_end"    select="@other_end" />
  <xsl:variable name="type"          select="@type" />
  
  <xsl:variable name="main_assembly">
    <xsl:choose>
      <xsl:when test="contains($coord_system,$previous_assembly)">
        <xsl:value-of select="$previous_assembly"/>
      </xsl:when>   
      <xsl:when test="contains($coord_system,$current_assembly)">
        <xsl:value-of select="$current_assembly"/> 
      </xsl:when> 
      <xsl:otherwise><xsl:value-of select="$coord_system"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
    
  <xsl:variable name="ensembl_url"><xsl:text>http://</xsl:text>
    <xsl:choose>  
      <xsl:when test="$main_assembly=$previous_assembly">
        <xsl:text>grch37</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>www</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>.ensembl.org/Homo_sapiens/Location/View?</xsl:text>
  </xsl:variable>
  
  <xsl:variable name="ensembl_region"><xsl:text>r=</xsl:text><xsl:value-of select="$region_name"/>:<xsl:value-of select="$region_start"/>-<xsl:value-of select="$region_end"/></xsl:variable>
  <xsl:variable name="ncbi_region">taxid=9606<xsl:text>&amp;</xsl:text>CHR=<xsl:value-of select="$region_name"/><xsl:text>&amp;</xsl:text>BEG=<xsl:value-of select="$region_start"/><xsl:text>&amp;</xsl:text>END=<xsl:value-of select="$region_end"/></xsl:variable>
  <xsl:variable name="ucsc_url">http://genome.ucsc.edu/cgi-bin/hgTracks?</xsl:variable>
  <xsl:variable name="ucsc_region">clade=mammal<xsl:text>&amp;</xsl:text>org=Human<xsl:text>&amp;</xsl:text>position=chr<xsl:value-of select="$region_name"/>:<xsl:value-of select="$region_start"/>-<xsl:value-of select="$region_end"/><xsl:text>&amp;</xsl:text>hgt.customText=<xsl:value-of select="$lrg_root_ftp" /><xsl:text>LRG_</xsl:text><xsl:value-of select="$main_assembly"/><xsl:text>.bed</xsl:text></xsl:variable>
  
  <xsl:choose>
    <xsl:when test="$region_name='X' or $region_name='Y' or $region_name='X' or number($region_name)">
      <h3 class="subsection icon-next-page smaller-icon">Mapping (assembly <xsl:value-of select="$coord_system"/>)</h3>
    </xsl:when>
    <xsl:otherwise>
      <h3 class="subsection icon-next-page smaller-icon">Mapping (assembly <xsl:value-of select="$coord_system"/>) - <span style="color:#E00">Patched region</span></h3>
    </xsl:otherwise>
  </xsl:choose>

  <p>
    <xsl:variable name="region_display">
      <xsl:choose>
        <xsl:when test="$region_name='unlocalized'">
          <xsl:value-of select="$region_id"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$region_name"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
  
    <span class="line_header">Region covered:</span><span class="external_link"><span class="blue"><xsl:value-of select="$region_display"/></span>:<xsl:value-of select="$region_start"/>-<xsl:value-of select="$region_end"/></span>
    
    <!-- Region synonyms for the patches and haplotypes -->
    <xsl:if test="$type='patch' or $type='haplotype'">
      <span class="blue" style="margin-left:15px;margin-right:15px">|</span>
      <span style="margin-right:10px;font-weight:bold">Region synonym(s):</span>
      <span class="external_link">
      <xsl:if test="$region_name!='unlocalized'">
        <xsl:value-of select="$region_id"/>, 
      </xsl:if>
      <xsl:value-of select="$region_id_syn"/>
      </span>
    </xsl:if>
    
    <span class="blue" style="margin-left:15px;margin-right:15px">|</span>
    <span style="margin-right:10px;font-weight:bold">See in:</span>
    <xsl:choose>
      <xsl:when test="$type='main_assembly' or $type='other_assembly'">

    <!-- Ensembl link -->  
    <a>
      <xsl:attribute name="class">icon-external-link</xsl:attribute>
      <xsl:attribute name="target">_blank</xsl:attribute>
      <xsl:attribute name="href">
        <xsl:value-of select="$ensembl_url" />
        <xsl:value-of select="$ensembl_region" />
        <xsl:text>&amp;</xsl:text><xsl:text>contigviewbottom=url:ftp://ftp.ebi.ac.uk/pub/databases/lrgex/.ensembl_internal/</xsl:text><xsl:value-of select="$lrg_id"/><xsl:text>_</xsl:text><xsl:value-of select="$main_assembly"/><xsl:text>.gff=labels,variation_feature_variation=normal,variation_set_ph_variants=normal</xsl:text>
      </xsl:attribute>Ensembl
    </a>
    
    <span style="margin-left:5px;margin-right:10px">-</span>
        
    <!-- NCBI link -->
    <a>
      <xsl:attribute name="class">icon-external-link</xsl:attribute>
      <xsl:attribute name="target">_blank</xsl:attribute>
      <xsl:attribute name="href">
        <xsl:value-of select="$ncbi_url_map" />
        <xsl:value-of select="$ncbi_region" />
        <xsl:if test="$main_assembly=$previous_assembly">
          <xsl:text>&amp;</xsl:text>build=105.0
        </xsl:if>
      </xsl:attribute>NCBI
    </a>
    
    <!-- UCSC link -->  
    <span style="margin-left:5px;margin-right:10px">-</span>
    <a>
      <xsl:attribute name="class">icon-external-link</xsl:attribute>
      <xsl:attribute name="target">_blank</xsl:attribute>
      <xsl:attribute name="href">
        <xsl:value-of select="$ucsc_url" />
        <xsl:value-of select="$ucsc_region" />
        <xsl:text>&amp;</xsl:text><xsl:text>db=hg</xsl:text>
        <xsl:choose>
          <xsl:when test="$main_assembly=$previous_assembly"><xsl:text>19</xsl:text></xsl:when>
          <xsl:otherwise><xsl:text>38</xsl:text></xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>UCSC
    </a>
      </xsl:when>
     
      <!-- Link to the NT NCBI page -->
      <xsl:otherwise>
     <a>
        <xsl:attribute name="class">icon-external-link</xsl:attribute>
        <xsl:attribute name="target">_blank</xsl:attribute>
        <xsl:attribute name="href">
          <xsl:value-of select="$ncbi_url" />
          <xsl:value-of select="$region_id" />
        </xsl:attribute>NCBI
    </a>   
      </xsl:otherwise>
      
    </xsl:choose>  
  </p>
    
  <xsl:call-template name="g_mapping_table">
    <xsl:with-param name="assembly"><xsl:value-of select="$coord_system"/></xsl:with-param>
    <xsl:with-param name="region_name"><xsl:value-of select="$region_name" /></xsl:with-param>
    <xsl:with-param name="region_id"><xsl:value-of select="$region_id" /></xsl:with-param>
  </xsl:call-template>
  
</xsl:template>


<xsl:template name="g_mapping_table">
  <xsl:param name="assembly" />
  <xsl:param name="region_name" />
  <xsl:param name="region_id" />
  
  <table class="table table-hover bordered">
    <thead>
      <tr class="gradient_color2">
        <th colspan="4">Reference assembly <xsl:value-of select="$assembly" /></th>
        <th colspan="2" style="color: #48a726">LRG</th>
      </tr>
      <tr class="sub_header">
        <th>Strand</th>
        <th>
          <xsl:choose>
            <xsl:when test="@type='main_assembly' or @type='other_assembly'">Chr</xsl:when>
            <xsl:otherwise>Region</xsl:otherwise>
          </xsl:choose>      
        </th>
        <th>Start</th>
        <th>End</th>
        <th>Start</th>
        <th>End</th>
        <th title="Sequence difference(s) between the reference genomic sequence and the LRG genomic sequence">Difference(s)</th>
      </tr>
    </thead>
    <tbody>
  <xsl:for-each select="mapping_span">
      <tr>
        <td><xsl:call-template name="strand_label"/></td>
        <td class="text_right"><xsl:value-of select="$region_name"/></td>
        <td class="text_right"><xsl:value-of select="@other_start"/></td>
        <td class="text_right"><xsl:value-of select="@other_end"/></td>
        <td class="text_right"><xsl:value-of select="@lrg_start"/></td>
        <td class="text_right"><xsl:value-of select="@lrg_end"/></td>
        <xsl:call-template name="diff_table"/>
      </tr>      
  </xsl:for-each>
    </tbody>
  </table>
  <br />
</xsl:template>


<!-- TRANSCRIPT MAPPING -->
<xsl:template name="t_mapping">
  <xsl:param name="lrg_id" />
  <xsl:param name="transcript_id" />
  
  <xsl:variable name="coord_system" select="@coord_system" />
  <xsl:variable name="region_name" select="@other_name" />
  <xsl:variable name="region_id" select="@other_id" />
  <xsl:variable name="region_start" select="@other_start" />
  <xsl:variable name="region_end" select="@other_end" />
  
  <xsl:variable name="ensembl_url"><xsl:value-of select="$ensembl_root_url"/><xsl:text>Transcript/Summary?t=</xsl:text><xsl:value-of select="$region_name"/></xsl:variable>
  <xsl:variable name="ensembl_region"><xsl:text>r=</xsl:text><xsl:value-of select="$region_name"/>:<xsl:value-of select="$region_start"/>-<xsl:value-of select="$region_end"/></xsl:variable>
  <div>
    <div class="show_hide_box" style="margin-top:2px;margin-left:0px">
      <xsl:call-template name="show_hide_button">
        <xsl:with-param name="div_id"><xsl:value-of select="$region_name"/></xsl:with-param>
      </xsl:call-template>
    </div>
    <div class="show_hide_box_text" style="margin-left:2px">
      <h3 class="mapping">Mapping of transcript <xsl:value-of select="$region_name"/> to <xsl:value-of select="$lrg_id"/></h3>
    </div>
    <div style="clear:both"></div>
  </div>
       
  <ul class="region"><li>
      <span style="font-weight:bold">Region covered:</span><span style="margin-left:10px"><xsl:value-of select="$region_id"/>:<xsl:value-of select="$region_start"/>-<xsl:value-of select="$region_end"/></span>
      <span class="blue" style="margin-left:15px;margin-right:15px">|</span>
      <span style="font-weight:bold;margin-right:5px">See in:</span>
    <xsl:choose>
      <xsl:when test="../source/name='Ensembl'">
        <a>
          <xsl:attribute name="class">icon-external-link</xsl:attribute>
          <xsl:attribute name="target">_blank</xsl:attribute>
          <xsl:attribute name="href">
            <xsl:value-of select="$ensembl_url" />
          </xsl:attribute>Ensembl
        </a>
      </xsl:when>
      <xsl:otherwise>
        <a>
          <xsl:attribute name="class">icon-external-link</xsl:attribute>
          <xsl:attribute name="target">_blank</xsl:attribute>
          <xsl:attribute name="href">
            <xsl:value-of select="$ncbi_url" />
            <xsl:value-of select="$region_id" />
          </xsl:attribute>NCBI
        </a>
      </xsl:otherwise> 
    </xsl:choose>  
  </li></ul>
  <div class="mapping">
    <div class="hidden">
      <xsl:attribute name="id">
        <xsl:value-of select="$region_name" />
      </xsl:attribute>
      <table class="table table-hover bordered">
        <thead>
          <tr class="gradient_color2">
            <th>Transcript start</th>
            <th>Transcript end</th>
            <th>LRG start</th>
            <th>LRG end</th>
            <th>Differences</th>
          </tr>
        </thead>
        <tbody>
    <xsl:for-each select="mapping_span">
          <tr>
            <td class="text_right"><xsl:value-of select="@other_start"/></td>
            <td class="text_right"><xsl:value-of select="@other_end"/></td>
            <td class="text_right"><xsl:value-of select="@lrg_start"/></td>
            <td class="text_right"><xsl:value-of select="@lrg_end"/></td>
            <xsl:call-template name="diff_table"/>
          </tr>      
    </xsl:for-each>
        </tbody>
      </table>
    </div>
  </div>
  <br />
</xsl:template>

<!-- Display the strand value -->
<xsl:template name="strand_label">
  <xsl:choose>
    <xsl:when test="@strand=1" ><span class="icon-next-page smaller-icon close-icon-5">Forward</span></xsl:when>
    <xsl:when test="@strand=-1"><span class="icon-previous-page smaller-icon close-icon-5">Reverse</span></xsl:when>
    <xsl:otherwise><xsl:value-of select="@strand"/></xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- Detect web addresses in a string and create hyperlinks -->
<xsl:template name="urlify">
  <xsl:param name="input_str" />
  
  <xsl:value-of select="$input_str" />
</xsl:template>


<!-- CDS COORDINATES -->
<xsl:template name="cds_coordinates">
  <xsl:param name="transname" />
  <xsl:param name="start_end" /> <!-- start | end -->
  
  <xsl:for-each select="/*/fixed_annotation/transcript[@name = $transname]/coding_region">
    <xsl:sort select="substring-after(translation/@name,'p')" data-type="number" />
    <xsl:if test="position()=1">
      <xsl:choose>
        <xsl:when test="$start_end='start'">
          <xsl:value-of select="coordinates[@coord_system = $lrg_coord_system]/@start" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="coordinates[@coord_system = $lrg_coord_system]/@end" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:for-each>
</xsl:template>


<!-- COMMENT -->
<xsl:template name="comment">
  <xsl:param name="lrg_id"/>
  <xsl:param name="transname"/>
  <xsl:param name="setnum"/>
  <p>
  <xsl:call-template name="urlify">
    <xsl:with-param name="input_str"><xsl:value-of select="." /></xsl:with-param>
  </xsl:call-template>
  </p>
</xsl:template>


<!-- OTHER EXON NAMING -->
<xsl:template name="additional_exon_numbering">
  <xsl:param name="lrg_id"/>
  <xsl:param name="transname"/>
  <xsl:param name="setnum"/>
  
  <xsl:if test="/*/updatable_annotation/annotation_set/fixed_transcript_annotation[@name = $transname]/other_exon_naming">
    <xsl:variable name="exons_id"><xsl:value-of select="$transname" />_other_naming</xsl:variable>
    <xsl:variable name="ref_transcript" select="/*/updatable_annotation/annotation_set[source[1]/name = $ncbi_source_name]/features/gene/transcript[@fixed_id = $transname]" />
    <div style="padding: 6px 0px">
      <div class="show_hide_box">
        <xsl:call-template name="show_hide_button">
          <xsl:with-param name="div_id">exontable_<xsl:value-of select="$exons_id"/></xsl:with-param>
        </xsl:call-template>
      </div>
      <div class="show_hide_box_text external_link">
        <span class="line_header">Transcript <span class="blue"><xsl:value-of select="$transname"/></span></span>
        <xsl:if test="$ref_transcript">(<xsl:value-of select="$ref_transcript/@accession" />)</xsl:if>
      </div>
      <div style="clear:both"></div>
    </div>   
    <xsl:call-template name="exons">
      <xsl:with-param name="exons_id"><xsl:value-of select="$exons_id" /></xsl:with-param>
      <xsl:with-param name="transname"><xsl:value-of select="$transname" /></xsl:with-param>
      <xsl:with-param name="show_other_exon_naming">1</xsl:with-param>
    </xsl:call-template>
  </xsl:if>
</xsl:template>
  

<!-- ALTERNATE AMINO ACID NUMBERING -->
<xsl:template match="alternate_amino_acid_numbering">  
  <xsl:param name="lrg_id"/>
  <xsl:param name="transname"/>
  <xsl:param name="setnum"/>
    
  <xsl:variable name="pname" select="translate($transname,'t','p')" />
  <xsl:variable name="aa_source_desc" select="@description" />
  
  <p>
    <ul>
      <li>
        <span class="line_header">Protein <span class="blue"><xsl:value-of select="$pname"/></span></span>
      </li>
    </ul>
  </p>
    <table class="table table-hover bordered">
      <thead>
        <tr class="gradient_color2">
          <th colspan="2">LRG-specific amino acid numbering</th>
          <th class="other_separator"> </th>
          <th colspan="2" class="dark_blue">
            <!--Alternative amino acid numbering based on LSDB sources-->
            <xsl:choose>
              <xsl:when test="url">
                <a>
                  <xsl:attribute name="class">icon-external-link</xsl:attribute>
                  <xsl:attribute name="class">header_link other_label</xsl:attribute>
                  <xsl:attribute name="href"><xsl:value-of select="url" /></xsl:attribute>
                  <xsl:attribute name="title">see further explanations</xsl:attribute>
                  <xsl:value-of select="$aa_source_desc" />
                </a>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$aa_source_desc" />
              </xsl:otherwise>
            </xsl:choose>
          </th>
        </tr>
        <tr class="sub_header">
          <th>Start</th>
          <th>End</th>
          <th class="other_separator"> </th>
          <th class="sub_other_label">Start</th>
          <th class="sub_other_label">End</th>
        </tr>
      </thead>
      <tbody>
    <xsl:for-each select="align">
        <tr style="background-color:#FFF">
          <td><xsl:value-of select="@lrg_start"/></td>
          <td><xsl:value-of select="@lrg_end"/></td>
          <td class="other_separator"></td>
          <td><xsl:value-of select="@start"/></td>
          <td><xsl:value-of select="@end"/></td>
        </tr>
    </xsl:for-each>
      </tbody>
    </table>
  
</xsl:template>


<!-- EXON NUMBERING -->
<xsl:template name="exons">
  <xsl:param name="exons_id"/>
  <xsl:param name="transname"/>
  <xsl:param name="show_other_exon_naming"/>
  
  <xsl:variable name="cdna_coord_system" select="concat($lrg_id,$transname)" />
  <xsl:variable name="lrg_exon">LRG-specific numbering for all exons</xsl:variable>
  

  <xsl:variable name="ref_start">
    <xsl:if test="/*/updatable_annotation/annotation_set[@type='lrg']/mapping[@type='main_assembly']">
      <xsl:value-of select="/*/updatable_annotation/annotation_set[@type='lrg']/mapping[contains(@coord_system,$current_assembly) and @type='main_assembly']/@other_start"/> 
    </xsl:if>
  </xsl:variable>
  <xsl:variable name="ref_end">
    <xsl:if test="/*/updatable_annotation/annotation_set[@type='lrg']/mapping[@type='main_assembly']">
      <xsl:value-of select="/*/updatable_annotation/annotation_set[@type='lrg']/mapping[contains(@coord_system,$current_assembly) and @type='main_assembly']/@other_end"/> 
    </xsl:if>
  </xsl:variable>
  <xsl:variable name="ref_strand">
    <xsl:if test="/*/updatable_annotation/annotation_set[@type='lrg']/mapping[@type='main_assembly']">
      <xsl:value-of select="/*/updatable_annotation/annotation_set[@type='lrg']/mapping[contains(@coord_system,$current_assembly) and @type='main_assembly']/mapping_span/@strand"/> 
    </xsl:if>
  </xsl:variable>
  
  <div>
    <xsl:attribute name="id">exontable_<xsl:value-of select="$exons_id"/></xsl:attribute>
    <xsl:attribute name="class">hidden</xsl:attribute>

    <div class="unhidden_content">
    
      <div style="padding-left:5px;margin-bottom:10px;max-width:75%">
        <div class="seq_info_box">
          <div class="seq_info_header">Information</div>
          <ul class="seq_info">
            <li><span class="partial sequence_padding">Shading</span> indicates exon contains CDS start or end.</li>
            <li>
              Click on exons to highlight - exons are highlighted in all sequences and exon table. 
              Highlighting helps to distinguish the different exons e.g. <span class="introntableselect sequence_padding">EXON 1</span> / <span class="exontableselect sequence_padding">EXON 2</span>
              <xsl:call-template name="clear_exon_highlights">
                <xsl:with-param name="transname"><xsl:value-of select="$transname"/></xsl:with-param>
              </xsl:call-template>
            </li>
          </ul>
        </div>
      </div>

    <xsl:for-each select="/*/fixed_annotation/transcript[@name = $transname]/coding_region">
      <xsl:sort select="substring-after(translation/@name,'p')" data-type="number" />

      <xsl:variable name="cds_start" select="coordinates[@coord_system = $lrg_coord_system]/@start" />
      <xsl:variable name="cds_end" select="coordinates[@coord_system = $lrg_coord_system]/@end" />
      <xsl:variable name="pepname"><xsl:value-of select="translation/@name" /></xsl:variable>
      <xsl:variable name="peptide_coord_system" select="concat($lrg_id,$pepname)" />
      <xsl:if test="position()!=1"><br /></xsl:if>
      <table class="table bordered">
        <thead>
          <tr class="gradient_color2">
            <th class="border_separator" colspan="3">LRG genomic</th>
            <th class="border_separator" colspan="2">Transcript</th>
            <th class="border_separator" colspan="2">CDS</th>
            <th class="border_separator" colspan="2">Protein <xsl:value-of select="$pepname" /></th>
           <xsl:if test="$ref_start">
            <th class="border_separator" colspan="2"><xsl:value-of select="$current_assembly"/></th>
           </xsl:if> 
            <th>Intron</th>
          <xsl:if test="$show_other_exon_naming=1 and /*/updatable_annotation/annotation_set/fixed_transcript_annotation[@name = $transname]/other_exon_naming">
            <th class="other_separator"> </th>
            <th colspan="100" class="other_label">Source of exon numbering</th>
          </xsl:if>
          </tr>
          <tr class="sub_header">
            <th>LRG-specific exon numbering</th>
            <th>Start</th><th class="border_separator">End</th>
            <th>Start</th><th class="border_separator">End</th>
            <th>Start</th><th class="border_separator">End</th>
            <th>Start</th><th class="border_separator">End</th>
          <xsl:if test="$ref_start">
            <th>Start</th><th class="border_separator">End</th>
          </xsl:if>
            <th>Phase</th>

        <xsl:if test="$show_other_exon_naming=1">
          <xsl:for-each select="/*/updatable_annotation/annotation_set">
            <xsl:variable name="setnum" select="position()"/>
            <xsl:variable name="setname" select="source[1]/name" />
            <xsl:for-each select="fixed_transcript_annotation[@name = $transname]/other_exon_naming">
              <xsl:variable name="desc" select="@description"/>
              <xsl:if test="position()=1">
                <th class="other_separator"></th>
              </xsl:if>
                <th class="sub_other_label">
                  <xsl:choose>
                    <xsl:when test="url">
                      <a class="other_label icon-external-link" target="_blank">
                        <xsl:attribute name="href"><xsl:value-of select="url" /></xsl:attribute>
                        <xsl:attribute name="title">see further explanations</xsl:attribute>
                        <xsl:value-of select="$desc"/>
                      </a>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="$desc"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </th>
            </xsl:for-each>
          </xsl:for-each>
        </xsl:if>
          </tr>
        </thead>
        <tbody>
      <xsl:variable name="cds_offset">
        <xsl:for-each select="/*/fixed_annotation/transcript[@name = $transname]/exon">
          <xsl:variable name="lrg_start" select="coordinates[@coord_system = $lrg_coord_system]/@start" />
          <xsl:variable name="lrg_end" select="coordinates[@coord_system = $lrg_coord_system]/@end" />
          <xsl:variable name="cdna_start" select="coordinates[@coord_system = $cdna_coord_system]/@start" />
          <xsl:if test="($lrg_start &lt; $cds_start or $lrg_start = $cds_start) and ($lrg_end &gt; $cds_start or $lrg_end = $cds_start)">
            <xsl:value-of select="$cdna_start + $cds_start - $lrg_start"/>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>
     
      <xsl:for-each select="/*/fixed_annotation/transcript[@name = $transname]/exon">
        <xsl:variable name="exon_label" select="@label" />
        <xsl:variable name="lrg_start" select="coordinates[@coord_system = $lrg_coord_system]/@start" />
        <xsl:variable name="lrg_end" select="coordinates[@coord_system = $lrg_coord_system]/@end" />
        <xsl:variable name="cdna_start" select="coordinates[@coord_system = $cdna_coord_system]/@start" />
        <xsl:variable name="cdna_end" select="coordinates[@coord_system = $cdna_coord_system]/@end" />
        <xsl:variable name="peptide_start" select="coordinates[@coord_system = $peptide_coord_system]/@start"/>
        <xsl:variable name="peptide_end" select="coordinates[@coord_system = $peptide_coord_system]/@end"/>
        <xsl:variable name="exon_number" select="position()"/>
        
        <!-- Genomic reference assembly coordinates -->
        <xsl:variable name="temp_lrg_ref_start">
          <xsl:choose>
            <xsl:when test="$ref_strand = 1">
              <xsl:value-of select="$ref_start + $lrg_start - 1"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$ref_end - $lrg_start + 1"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="temp_lrg_ref_end">
          <xsl:choose>
            <xsl:when test="$ref_strand = 1">
              <xsl:value-of select="$ref_start + $lrg_end - 1"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$ref_end - $lrg_end + 1"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="lrg_ref_start">
          <xsl:choose>
            <xsl:when test="/*/updatable_annotation/annotation_set[@type='lrg']/mapping[@type='main_assembly']/mapping_span/diff">
                <xsl:for-each select="/*/updatable_annotation/annotation_set[@type='lrg']/mapping[@type='main_assembly']/mapping_span">

                  <xsl:call-template name="diff_coords">
                    <xsl:with-param name="item" select="diff[1]"/>
                    <xsl:with-param name="lrg_start" select="$lrg_start"/>
                    <xsl:with-param name="lrg_end" select="$lrg_end"/>
                    <xsl:with-param name="ref_strand" select="$ref_strand"/>
                    <xsl:with-param name="ctype">start</xsl:with-param>
                    <xsl:with-param name="coord" select="$temp_lrg_ref_start"/>
                  </xsl:call-template>

                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$temp_lrg_ref_start"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="lrg_ref_end">
          <xsl:choose>
            <xsl:when test="/*/updatable_annotation/annotation_set[@type='lrg']/mapping[@type='main_assembly']/mapping_span/diff">
                <xsl:for-each select="/*/updatable_annotation/annotation_set[@type='lrg']/mapping[@type='main_assembly']/mapping_span">

                  <xsl:call-template name="diff_coords">
                    <xsl:with-param name="item" select="diff[1]"/>
                    <xsl:with-param name="lrg_start" select="$lrg_start"/>
                    <xsl:with-param name="lrg_end" select="$lrg_end"/>
                    <xsl:with-param name="ref_strand" select="$ref_strand"/>
                    <xsl:with-param name="ctype">end</xsl:with-param>
                    <xsl:with-param name="coord" select="$temp_lrg_ref_end"/>
                  </xsl:call-template>

                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$temp_lrg_ref_end"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

          <tr align="right">
            <xsl:attribute name="id">table_exon_<xsl:value-of select="$exons_id"/>_<xsl:value-of select="$pepname"/>_<xsl:value-of select="$exon_number"/></xsl:attribute>
            <xsl:attribute name="onclick">javascript:highlight_exon('<xsl:value-of select="$transname"/>','<xsl:value-of select="$exon_number"/>','<xsl:value-of select="$pepname"/>')</xsl:attribute>
            <xsl:choose>
              <xsl:when test="round(position() div 2) = (position() div 2)">
                <xsl:attribute name="class">exontable</xsl:attribute>
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="class">introntable</xsl:attribute>
              </xsl:otherwise>
            </xsl:choose>
           
            <td><xsl:value-of select="$exon_label"/></td>
            <td><xsl:value-of select="$lrg_start"/></td>
            <td class="border_separator"><xsl:value-of select="$lrg_end"/></td>
            <td><xsl:value-of select="$cdna_start"/></td>
            <td class="border_separator"><xsl:value-of select="$cdna_end"/></td>
          
          <xsl:call-template name="cds_exon_coords">
            <xsl:with-param name="lrg_start" select="$lrg_start"/>
            <xsl:with-param name="lrg_end" select="$lrg_end"/>
            <xsl:with-param name="cdna_start" select="$cdna_start"/>
            <xsl:with-param name="cdna_end" select="$cdna_end"/>
            <xsl:with-param name="cds_start" select="$cds_start"/>
            <xsl:with-param name="cds_end" select="$cds_end"/>
            <xsl:with-param name="cds_offset" select="$cds_offset"/>
          </xsl:call-template>

          <xsl:choose>
            <xsl:when test="$lrg_end &gt; $cds_start and $lrg_start &lt; $cds_end">
            <td>
              <xsl:if test="$lrg_start &lt; $cds_start">
                <xsl:attribute name="class">partial</xsl:attribute>
              </xsl:if>
              <xsl:value-of select="$peptide_start"/>
            </td>         
            <td>
              <xsl:choose>
                <xsl:when test="$lrg_end &gt; $cds_end">
                  <xsl:attribute name="class">border_separator partial</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="class">border_separator</xsl:attribute>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:value-of select="$peptide_end"/>
            </td>
            </xsl:when>
            <xsl:otherwise>
            <td>-</td>
            <td class="border_separator">-</td>
            </xsl:otherwise>
          </xsl:choose>
      
          <!-- Reference genomic coordinates -->
          <td><xsl:value-of select="$lrg_ref_start"/></td>
          <td class="border_separator"><xsl:value-of select="$lrg_ref_end"/></td>
      
            <td>
          <xsl:choose>
            <xsl:when test="name(following-sibling::*[1]) = 'intron'">
              <xsl:value-of select="following-sibling::intron[1]/@phase"/>
            </xsl:when>
            <xsl:otherwise>-</xsl:otherwise>
          </xsl:choose>
            </td>
      
          <xsl:if test="$show_other_exon_naming=1">  
            <xsl:for-each select="/*/updatable_annotation/annotation_set">
              <xsl:if test="position()=1">
              <td class="other_separator"></td>
              </xsl:if>
              <xsl:for-each select="fixed_transcript_annotation[@name = $transname]/other_exon_naming">
                <xsl:variable name="setnum" select="position()"/>
                <xsl:variable name="label" select="exon[coordinates[@coord_system = $lrg_coord_system and @start=$lrg_start and @end=$lrg_end]]/label" />
              <td>
                <xsl:choose>
                  <xsl:when test="$label">
                    <xsl:choose>
                       <xsl:when test="$label = $exon_label">
                          <xsl:value-of select="$label"/>
                       </xsl:when>  
                       <xsl:otherwise>
                         <span class="blue">
                           <xsl:attribute name="style">cursor:default</xsl:attribute>
                           <xsl:attribute name="title">Different from the LRG-specific exon numbering (<xsl:value-of select="$exon_label"/>)</xsl:attribute>
                           <xsl:value-of select="$label"/>
                         </span>
                       </xsl:otherwise>
                     </xsl:choose>
                  </xsl:when>
                  <xsl:otherwise>Same as the specific numbering</xsl:otherwise>
                </xsl:choose>
              </td>
              </xsl:for-each>
            </xsl:for-each>
          </xsl:if>
          </tr>
      
      </xsl:for-each>
        </tbody>
      </table>
    </xsl:for-each>

    <!-- Non coding exons -->
    <xsl:if test="not(/*/fixed_annotation/transcript[@name = $transname]/coding_region)">
      <xsl:call-template name="non_coding_exons">
        <xsl:with-param name="exons_id"><xsl:value-of select="$exons_id" /></xsl:with-param>
        <xsl:with-param name="transname"><xsl:value-of select="$transname" /></xsl:with-param>
        <xsl:with-param name="cdna_coord_system"><xsl:value-of select="$cdna_coord_system" /></xsl:with-param>
        <xsl:with-param name="show_other_exon_naming"><xsl:value-of select="$show_other_exon_naming" /></xsl:with-param>
      </xsl:call-template>
    </xsl:if>
      <div style="padding-left:5px;margin:10px 0px">
        <xsl:call-template name="hide_button">
          <xsl:with-param name="div_id">exontable_<xsl:value-of select="$exons_id"/></xsl:with-param>
        </xsl:call-template>
      </div>
    </div>
  </div>
</xsl:template>


<!-- Calcualte the mapped coordinates to the main assembly taking into account the seq differences -->
<xsl:template name="diff_coords">
  <xsl:param name="item"/>
  <xsl:param name="lrg_start"/>
  <xsl:param name="lrg_end"/>
  <xsl:param name="ref_strand"/>
  <xsl:param name="ctype"/>
  <xsl:param name="coord"/>

  <xsl:choose>
    <xsl:when test="not($item)">
      <!--* done, return result *-->
      <xsl:value-of select="$coord"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="coord_diff">
        <xsl:choose>
          <xsl:when test="$item/@type!='mismatch' and (($item/@lrg_start &lt; $lrg_start and $ctype='start') or ($item/@lrg_end &lt; $lrg_end and $ctype='end'))">
          
            <xsl:choose>
             
              <!-- Forward strand -->
              <xsl:when test="$ref_strand = 1">
                 
                <xsl:choose>
                  <!-- LRG insertion -->
                  <xsl:when test="$item/@type = 'lrg_ins'">
                    <xsl:value-of select="$coord - ($item/@lrg_end - $item/@lrg_start + 1)"/>
                  </xsl:when>
                  <!-- LRG deletion -->
                  <xsl:when test="$item/@type = 'other_ins'">
                    <xsl:value-of select="$coord + ($item/@other_end - $item/@other_start + 1)"/>
                  </xsl:when>
                </xsl:choose>
                 
              </xsl:when>
               
              <!-- Reverse strand -->
              <xsl:when test="$ref_strand = -1">
                 
                <xsl:choose>
                  <!-- LRG insertion -->
                  <xsl:when test="$item/@type = 'lrg_ins'">
                    <xsl:value-of select="$coord + ($item/@lrg_end - $item/@lrg_start + 1)"/>
                  </xsl:when>
                  <!-- LRG deletion -->
                  <xsl:when test="$item/@type = 'other_ins'">
                    <xsl:value-of select="$coord - ($item/@other_end - $item/@other_start + 1)"/>
                  </xsl:when>
                </xsl:choose>
                 
              </xsl:when>
              
            </xsl:choose>
             
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$coord" />
          </xsl:otherwise>
        </xsl:choose>
        
      </xsl:variable>
    
      <!-- Recursive call -->
      <xsl:call-template name="diff_coords">
        <xsl:with-param name="item" select="$item/following-sibling::diff[1]"/>
        <xsl:with-param name="lrg_start" select="$lrg_start"/>
        <xsl:with-param name="lrg_end" select="$lrg_end"/>
        <xsl:with-param name="ref_strand" select="$ref_strand"/>
        <xsl:with-param name="ctype" select="$ctype"/>
        <xsl:with-param name="coord" select="$coord_diff"/>
      </xsl:call-template>
      
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- Display for the non coding exons -->
<xsl:template name="non_coding_exons">
  <xsl:param name="exons_id"/>
  <xsl:param name="transname"/>
  <xsl:param name="cdna_coord_system" />
  <xsl:param name="show_other_exon_naming"/>
    <table class="table bordered">
      <thead>
        <tr class="gradient_color2">
          <th colspan="2">LRG genomic</th>
          <th colspan="2">Transcript</th>
          <th>Intron</th>
        <xsl:if test="$show_other_exon_naming=1 and /*/updatable_annotation/annotation_set/fixed_transcript_annotation[@name = $transname]/other_exon_naming">
          <th class="other_separator"> </th>
          <th colspan="100" class="other_label">Source of exon numbering</th>
        </xsl:if>
        </tr>
        <tr class="sub_header">
          <th>Number</th>
          <th>Start</th><th>End</th>
          <th>Start</th><th>End</th>
          <th>Phase</th>

      <xsl:if test="$show_other_exon_naming=1">
        <xsl:for-each select="/*/updatable_annotation/annotation_set">
          <xsl:variable name="setnum" select="position()"/>
          <xsl:variable name="setname" select="source[1]/name" />
          <xsl:for-each select="fixed_transcript_annotation[@name = $transname]/other_exon_naming">
            <xsl:if test="position()=1">
              <th class="other_separator"></th>
            </xsl:if>
              <th class="other_label">
                <a class="other_label">
                  <xsl:attribute name="href">#fixed_transcript_annotation_aa_set_<xsl:value-of select="$setnum"/></xsl:attribute>
                  <xsl:attribute name="title"><xsl:value-of select="@description"/></xsl:attribute>
                  <xsl:value-of select="@description"/>
                </a>
              </th>
          </xsl:for-each>
        </xsl:for-each>
      </xsl:if>
        </tr>
      </thead>
      <tbody>
      <xsl:for-each select="/*/fixed_annotation/transcript[@name = $transname]/exon">
        <xsl:variable name="other_label" select="@label" />
        <xsl:variable name="lrg_start" select="coordinates[@coord_system = $lrg_coord_system]/@start" />
        <xsl:variable name="lrg_end" select="coordinates[@coord_system = $lrg_coord_system]/@end" />
        <xsl:variable name="cdna_start" select="coordinates[@coord_system = $cdna_coord_system]/@start" />
        <xsl:variable name="cdna_end" select="coordinates[@coord_system = $cdna_coord_system]/@end" />
        <xsl:variable name="exon_number" select="position()"/>

        <tr align="right">
          <xsl:attribute name="id">table_exon_<xsl:value-of select="$exons_id"/>__<xsl:value-of select="$exon_number"/></xsl:attribute>
          <xsl:attribute name="onclick">javascript:highlight_exon('<xsl:value-of select="$transname"/>','<xsl:value-of select="$exon_number"/>')</xsl:attribute>
          <xsl:choose>
            <xsl:when test="round(position() div 2) = (position() div 2)">
              <xsl:attribute name="class">exontable</xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="class">introntable</xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
        
          <td><xsl:value-of select="$other_label"/></td>
          <td><xsl:value-of select="$lrg_start"/></td>
          <td><xsl:value-of select="$lrg_end"/></td>
          <td><xsl:value-of select="$cdna_start"/></td>
          <td><xsl:value-of select="$cdna_end"/></td>
    
          <td>
        <xsl:choose>
          <xsl:when test="name(following-sibling::*[1]) = 'intron'">
            <xsl:value-of select="following-sibling::intron[1]/@phase"/>
          </xsl:when>
          <xsl:otherwise>-</xsl:otherwise>
        </xsl:choose>
          </td>
    
        <xsl:if test="$show_other_exon_naming=1">  
          <xsl:for-each select="/*/updatable_annotation/annotation_set">
            <xsl:if test="position()=1">
            <th class="other_separator" />
            </xsl:if>
            <xsl:for-each select="fixed_transcript_annotation[@name = $transname]/other_exon_naming">
              <xsl:variable name="setnum" select="position()"/>
              <xsl:variable name="label" select="exon[coordinates[@coord_system = $lrg_coord_system and @start=$lrg_start and @end=$lrg_end]]" />
            <td>
              <xsl:choose>
                <xsl:when test="$label">
                   <xsl:value-of select="$label"/>
                </xsl:when>
                <xsl:otherwise>-</xsl:otherwise>
              </xsl:choose>
            </td>
            </xsl:for-each>
          </xsl:for-each>
        </xsl:if>
        </tr>
      
      </xsl:for-each>
      </tbody>    
    </table>
</xsl:template>


<!-- Transcript image -->  
<xsl:template name="transcript_image">
  <xsl:param name="transname"/>
  <xsl:param name="cdna_coord_system"/>
  
  <xsl:variable name="tr_start" select="coordinates[@coord_system = $lrg_coord_system]/@start" />
  <xsl:variable name="tr_end" select="coordinates[@coord_system = $lrg_coord_system]/@end" /> 
  
  <xsl:variable name="tr_length" select="$tr_end - $tr_start + 1"/>
  
  <xsl:variable name="cds_start" select="coding_region[position() = 1]/coordinates[@coord_system = $lrg_coord_system]/@start" />
  <xsl:variable name="cds_end" select="coding_region[position() = 1]/coordinates[@coord_system = $lrg_coord_system]/@end" />
  
  <xsl:variable name="pepname" select="coding_region[position() = 1]/translation[position() = 1]/@name" />
  <div class="transcript_image_container">   
    <div class="transcript_image clearfix">
      <xsl:attribute name="style">
        <xsl:text>width:</xsl:text><xsl:value-of select="$image_width" /><xsl:text>px</xsl:text>
      </xsl:attribute>
      
      <xsl:variable name="cds_start_percent" select="($cds_start - $tr_start) div $tr_length"/>
      <xsl:variable name="cds_pos_start" select="format-number(($cds_start_percent * $image_width),0)" />
    
      <xsl:variable name="cds_width_percent" select="($cds_end - $cds_start + 1) div $tr_length"/>
      <xsl:variable name="cds_width" select="format-number(($cds_width_percent * $image_width),0)"/>
      
      <div>
        <xsl:attribute name="class">intron_line</xsl:attribute>
        <xsl:attribute name="style">
          <xsl:text>width:</xsl:text><xsl:value-of select="$image_width - 2" /><xsl:text>px</xsl:text>
        </xsl:attribute>
      </div>
      
    <xsl:for-each select="exon">
      <xsl:variable name="exon_label" select="@label" />
      <xsl:variable name="lrg_start" select="coordinates[@coord_system = $lrg_coord_system]/@start" />
      <xsl:variable name="lrg_end" select="coordinates[@coord_system = $lrg_coord_system]/@end" />
      <xsl:variable name="cdna_start" select="coordinates[@coord_system = $cdna_coord_system]/@start" />
      <xsl:variable name="cdna_end" select="coordinates[@coord_system = $cdna_coord_system]/@end" />
      <xsl:variable name="exon_number" select="position()"/>
      
      <xsl:variable name="exon_id">tr_img_exon_<xsl:value-of select="$transname"/>_<xsl:value-of select="$exon_number"/></xsl:variable>
     
     
      <xsl:variable name="tr_exon_start_percent" select="($lrg_start - $tr_start) div $tr_length"/>
      <xsl:variable name="exon_pos_start" select="format-number(($tr_exon_start_percent * $image_width),0)"/>
      <xsl:variable name="exon_size" select="$lrg_end - $lrg_start + 1"/>
      
      <div data-placement="bottom" data-toggle="tooltip">
        <xsl:attribute name="id"><xsl:value-of select="$exon_id"/></xsl:attribute>
        <xsl:attribute name="title">
          Exon <xsl:value-of select="$exon_number"/> | 
          Coord.: <xsl:value-of select="$lrg_start"/>-<xsl:value-of select="$lrg_end"/> | 
          Size: <xsl:value-of select="$exon_size"/>nt | 
          <xsl:choose>
            <!-- Coding -->
            <xsl:when test="$cds_start &lt; $lrg_start and $cds_end &gt; $lrg_end">
              <xsl:text>Coding</xsl:text>
            </xsl:when>
            <!-- Non coding 5 prime -->
            <xsl:when test="$cds_start &gt; $lrg_start and $cds_start &gt; $lrg_end">
              <xsl:text>Non coding (UTR)</xsl:text>
            </xsl:when>
            <!-- Non coding 3 prime -->
            <xsl:when test="$cds_end &lt; $lrg_start and $cds_end &lt; $lrg_end">
              <xsl:text>Non coding (UTR)</xsl:text>
            </xsl:when>
            <!-- Partially coding (UTR) -->
            <xsl:otherwise>
              <xsl:text>Partially coding (UTR)</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="onclick">javascript:highlight_exon('<xsl:value-of select="$transname"/>','<xsl:value-of select="$exon_number"/>','<xsl:value-of select="$pepname"/>');showhide('exontable_<xsl:value-of select="$transname"/>',1);</xsl:attribute>
      
      <xsl:choose>
        <!-- 5 prime UTR -->
        <xsl:when test="$lrg_start &lt; $cds_start">
    
          <xsl:choose>
            <xsl:when test="$cds_start &lt; $lrg_end">
              <xsl:attribute name="class">exon_block exon_block_large</xsl:attribute>
              <xsl:attribute name="style">
                <xsl:text>left:</xsl:text>
                <xsl:value-of select="$exon_pos_start" />
                <xsl:text>px</xsl:text>
              </xsl:attribute>
           
              <xsl:variable name="tr_exon_nc_width_percent" select="($cds_start - $lrg_start + 1) div $tr_length"/>
              <xsl:variable name="exon_nc_width">
                <xsl:call-template name="exon_width">
                  <xsl:with-param name="exon_width_percent"><xsl:value-of select="$tr_exon_nc_width_percent" /></xsl:with-param>
                </xsl:call-template>
              </xsl:variable>
                
              <div>
                <xsl:attribute name="class">exon_block exon_block_small exon_block_non_coding_5_prime</xsl:attribute>
                <xsl:attribute name="style">
                  <xsl:text>width:</xsl:text><xsl:value-of select="$exon_nc_width" /><xsl:text>px</xsl:text>
                </xsl:attribute>
              </div>
                
              <xsl:variable name="tr_exon_c_width_percent" select="($lrg_end - $cds_start + 1) div $tr_length"/>
              <xsl:variable name="exon_c_width">
                <xsl:call-template name="exon_width">
                  <xsl:with-param name="exon_width_percent"><xsl:value-of select="$tr_exon_c_width_percent" /></xsl:with-param>
                </xsl:call-template>
              </xsl:variable>
                
              <div>
                <xsl:attribute name="class">exon_block exon_block_medium exon_block_coding</xsl:attribute>
                <xsl:attribute name="style">
                  <xsl:text>width:</xsl:text><xsl:value-of select="$exon_c_width" /><xsl:text>px</xsl:text>
                </xsl:attribute>
              </div>
            </xsl:when>
            <!-- Fully non coding exon -->
            <xsl:otherwise>
              <xsl:variable name="tr_exon_width_percent" select="($lrg_end - $lrg_start + 1) div $tr_length"/>
              <xsl:variable name="exon_width">
                <xsl:call-template name="exon_width">
                  <xsl:with-param name="exon_width_percent"><xsl:value-of select="$tr_exon_width_percent" /></xsl:with-param>
                </xsl:call-template>
              </xsl:variable>
              
              <xsl:attribute name="class">exon_block exon_block_large exon_block_non_coding</xsl:attribute>
              <xsl:attribute name="style">
                <xsl:text>left:</xsl:text>
                <xsl:value-of select="$exon_pos_start" />
                <xsl:text>px;width:</xsl:text>
                <xsl:value-of select="$exon_width" />
                <xsl:text>px</xsl:text>
              </xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        
        <!-- 3 prime UTR -->
        <xsl:when test="$lrg_end &gt; $cds_end">
    
          <xsl:choose>
            <xsl:when test="$cds_end &gt; $lrg_start">
              
              <xsl:attribute name="class">exon_block exon_block_large</xsl:attribute>
              <xsl:attribute name="style">
                <xsl:text>left:</xsl:text>
                <xsl:value-of select="$exon_pos_start" />
                <xsl:text>px</xsl:text>
              </xsl:attribute>
            
              <xsl:variable name="tr_exon_c_width_percent" select="($cds_end - $lrg_start + 1) div $tr_length"/>
              <xsl:variable name="exon_c_width">
                <xsl:call-template name="exon_width">
                  <xsl:with-param name="exon_width_percent"><xsl:value-of select="$tr_exon_c_width_percent" /></xsl:with-param>
                </xsl:call-template>
              </xsl:variable>
              
              <div>
                <xsl:attribute name="class">exon_block exon_block_medium exon_block_coding</xsl:attribute>
                <xsl:attribute name="style">
                  <xsl:text>width:</xsl:text><xsl:value-of select="$exon_c_width" /><xsl:text>px</xsl:text>
                </xsl:attribute>
              </div>
              
              <xsl:variable name="tr_exon_nc_width_percent" select="($lrg_end - $cds_end + 1) div $tr_length"/>
              <xsl:variable name="exon_nc_width">
                <xsl:call-template name="exon_width">
                  <xsl:with-param name="exon_width_percent"><xsl:value-of select="$tr_exon_nc_width_percent" /></xsl:with-param>
                </xsl:call-template>
              </xsl:variable>
              
              <div>
                <xsl:attribute name="class">exon_block exon_block_small exon_block_non_coding_3_prime</xsl:attribute>
                <xsl:attribute name="style">
                  <xsl:text>width:</xsl:text><xsl:value-of select="$exon_nc_width" /><xsl:text>px</xsl:text>
                </xsl:attribute>
              </div>
            </xsl:when>
            <!-- Fully non coding exon -->
            <xsl:otherwise>
              <xsl:variable name="tr_exon_width_percent" select="($lrg_end - $lrg_start + 1) div $tr_length"/>
              <xsl:variable name="exon_width">
                <xsl:call-template name="exon_width">
                  <xsl:with-param name="exon_width_percent"><xsl:value-of select="$tr_exon_width_percent" /></xsl:with-param>
                </xsl:call-template>
              </xsl:variable>
              
              <xsl:attribute name="class">exon_block exon_block_large exon_block_non_coding</xsl:attribute>
              <xsl:attribute name="style">
                <xsl:text>left:</xsl:text>
                <xsl:value-of select="$exon_pos_start" />
                <xsl:text>px;width:</xsl:text>
                <xsl:value-of select="$exon_width" />
                <xsl:text>px</xsl:text>
              </xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        
        <!-- Fully coding exon -->
        <xsl:otherwise>
          
          <xsl:variable name="tr_exon_width_percent" select="($lrg_end - $lrg_start + 1) div $tr_length"/>
          <xsl:variable name="exon_width">
            <xsl:call-template name="exon_width">
              <xsl:with-param name="exon_width_percent"><xsl:value-of select="$tr_exon_width_percent" /></xsl:with-param>
            </xsl:call-template>
          </xsl:variable>
              
          <xsl:attribute name="class">exon_block exon_block_large exon_block_coding</xsl:attribute>
          <xsl:attribute name="style">
            <xsl:text>left:</xsl:text>
            <xsl:value-of select="$exon_pos_start" />
            <xsl:text>px;width:</xsl:text>
            <xsl:value-of select="$exon_width" />
            <xsl:text>px</xsl:text>
          </xsl:attribute>
        
        </xsl:otherwise>
      </xsl:choose>
      </div>
    </xsl:for-each>
    </div>
    <div class="clearfix" style="margin:5px;height:9px;border-left:1px solid #000;border-right:1px solid #000">
      <div style="border-top:1px solid #000;position:relative;top:4px"></div>
      <div style="float:left;background-color:#FFF;z-index:10;position:relative;top:-4px;left:4px;font-size:10px;color:#000;padding:0px 2px"><xsl:value-of select="$tr_start"/></div>
      <div style="float:right;background-color:#FFF;z-index:10;position:relative;top:-4px;right:4px;font-size:10px;color:#000;padding:0px 2px"><xsl:value-of select="$tr_end"/></div>
    </div>
  </div>
</xsl:template>


<!-- UPDATABLE ANNOTATION FEATURES -->  
<xsl:template match="features">
  <xsl:param name="lrg_id" />
  <xsl:param name="setnum" />
  
<!--  Display the genes -->
  <xsl:if test="gene/*">
    
    <xsl:variable name="has_hgnc_symbol">
      <xsl:choose>
        <xsl:when test="gene/symbol[@name=$lrg_gene_name and @source=$symbol_source]">1</xsl:when>
         <xsl:otherwise>0</xsl:otherwise>
      </xsl:choose>
    
    </xsl:variable>
    
    <xsl:for-each select="gene">
      <xsl:variable name="gene_idx" select="position()"/>
      <xsl:variable name="display_symbol"><xsl:value-of select="symbol/@name" /></xsl:variable>
      <xsl:variable name="display_symbol_source"><xsl:value-of select="symbol/@source" /></xsl:variable>

      <xsl:if test="$display_symbol=$lrg_gene_name">
        <xsl:if test="($has_hgnc_symbol=1 and $display_symbol_source=$symbol_source) or ($has_hgnc_symbol=0 and $display_symbol_source!=$symbol_source)">
          <xsl:variable name="mapping_anchor">mapping_anchor_<xsl:value-of select="@accession"/></xsl:variable>
          <h3 class="subsection icon-next-page smaller-icon">Gene <xsl:value-of select="$lrg_gene_name"/>
            <xsl:if test="$display_symbol_source!=$symbol_source">
              <span class="gene_source"> (<xsl:value-of select="$display_symbol_source"/>)</span>
            </xsl:if>
          </h3>
        
          <h3 class="sub_subsection gradient_color2">Gene annotations</h3>        
          <div class="transcript_mapping blue_bg">
            <div class="sub_transcript_mapping" style="padding:4px 2px">
              <xsl:call-template name="updatable_gene">
                <xsl:with-param name="lrg_id"><xsl:value-of select="$lrg_id" /></xsl:with-param>
                <xsl:with-param name="setnum"><xsl:value-of select="$setnum" /></xsl:with-param>
                <xsl:with-param name="gene_idx"><xsl:value-of select="position()" /></xsl:with-param>
                <xsl:with-param name="mapping_anchor">#<xsl:value-of select="$mapping_anchor" /></xsl:with-param>
                <xsl:with-param name="display_symbol"><xsl:value-of select="$display_symbol" /></xsl:with-param>
              </xsl:call-template>
            </div>
          </div>
      
          <!-- Displays the transcript mappings only if the gene name corresponds to the LRG gene name -->
     
          <!-- Insert the transcript mapping tables -->
          <xsl:if test="transcript/*">
          <h3 class="sub_subsection gradient_color2 blue_bg"><xsl:attribute name="id"><xsl:value-of select="$mapping_anchor"/></xsl:attribute>Mappings for <xsl:value-of select="$lrg_gene_name"/> transcript(s)</h3>
          <div class="transcript_mapping blue_bg">
            <div class="sub_transcript_mapping">
              <table>
                <tr><td class="transcript_mapping mapping"><br /></td></tr>
            <xsl:for-each select="transcript">
              <xsl:variable name="transcript_id" select="@accession" />
                <xsl:for-each select="../../../mapping">
                  <xsl:variable name="other_name_no_version" select="substring-before(@other_name,'.')" />
                  <xsl:if test="(@other_name=$transcript_id) or ($other_name_no_version=$transcript_id)">
                <tr><td class="transcript_mapping mapping">
                     <xsl:call-template name="t_mapping">
                     <xsl:with-param name="lrg_id"><xsl:value-of select="$lrg_id" /></xsl:with-param>
                     <xsl:with-param name="transcript_id"><xsl:value-of select="$transcript_id" /></xsl:with-param>
                   </xsl:call-template>
                </td></tr>
                  </xsl:if>
               </xsl:for-each>
            </xsl:for-each>
              </table>
            </div>
          </div>
          <br />
          </xsl:if>
        </xsl:if>
      </xsl:if>
    </xsl:for-each>
    
    <!--  Display the overlapping genes -->
    <xsl:if test="count(gene)>1">
      <h3 class="subsection icon-next-page smaller-icon">Overlapping gene(s)</h3>
      <xsl:for-each select="gene">
        <xsl:variable name="gene_idx" select="position()"/>
        <xsl:variable name="display_symbol"><xsl:value-of select="symbol/@name" /></xsl:variable>
        <xsl:variable name="display_symbol_source"><xsl:value-of select="symbol/@source" /></xsl:variable>
        
        <xsl:if test="($display_symbol!=$lrg_gene_name) or ($has_hgnc_symbol=1 and $display_symbol_source!=$symbol_source)">
          <xsl:variable name="mapping_anchor">mapping_anchor_<xsl:value-of select="@accession"/></xsl:variable>
          <h3 class="sub_subsection gradient_color2">Gene 
            <xsl:choose>
              <xsl:when test="$display_symbol_source=$symbol_source">
                <xsl:value-of select="$display_symbol" /> 
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="@accession" />
              </xsl:otherwise>
            </xsl:choose> 
          </h3>
          <div class="transcript_mapping">
            <div class="sub_transcript_mapping" style="padding:2px">
                <xsl:call-template name="updatable_gene">
                  <xsl:with-param name="lrg_id"><xsl:value-of select="$lrg_id" /></xsl:with-param>
                  <xsl:with-param name="setnum"><xsl:value-of select="$setnum" /></xsl:with-param>
                  <xsl:with-param name="gene_idx"><xsl:value-of select="position()" /></xsl:with-param>
                  <xsl:with-param name="mapping_anchor">#<xsl:value-of select="$mapping_anchor" /></xsl:with-param>
                  <xsl:with-param name="display_symbol"><xsl:value-of select="$display_symbol" /></xsl:with-param>
                </xsl:call-template>
            </div>
          </div>
          <br />
        </xsl:if>
      </xsl:for-each>
    </xsl:if>
  </xsl:if>
</xsl:template>

<!--  UPDATABLE GENE -->

<xsl:template name="updatable_gene">
  <xsl:param name="lrg_id" />
  <xsl:param name="setnum" />
  <xsl:param name="gene_idx" />
  <xsl:param name="mapping_anchor" />
  <xsl:param name="display_symbol" />
  
  <xsl:variable name="source" select="@source" />
  <xsl:variable name="accession" select="@accession" />
  <xsl:variable name="lrg_start" select="coordinates[@coord_system = $lrg_coord_system]/@start" />
  <xsl:variable name="lrg_end" select="coordinates[@coord_system = $lrg_coord_system]/@end" />
  <xsl:variable name="lrg_strand" select="coordinates[@coord_system = $lrg_coord_system]/@strand" />
  <xsl:variable name="gene_symbol_source" select="symbol/@source" />
  
    <div class="left_annotation">
      <p>
    <xsl:for-each select="long_name">
      <xsl:value-of select="."/><br/>
    </xsl:for-each>
      </p>
      
      <p>
    <xsl:if test="partial">
      <xsl:for-each select="partial">
        <strong>Note: </strong><xsl:value-of select="."/> end of this gene lies outside of the LRG<br/> 
      </xsl:for-each>
    </xsl:if>
        <strong>Synonym(s): </strong>
     <xsl:variable name="gene_symbol" select="symbol/synonym[not(.=$display_symbol)]"/>
     <xsl:if test="$gene_symbol">
      <xsl:for-each select="$gene_symbol">
        <xsl:value-of select="." />
        <xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if>
      </xsl:for-each>
    </xsl:if>
    <xsl:variable name="gene_synonym" select="db_xref[not(@source='GeneID')]/synonym"/>
    <xsl:if test="$gene_synonym">
      <xsl:for-each select="$gene_synonym">
        <xsl:if test="position() = 1 and $gene_symbol"><xsl:text>, </xsl:text></xsl:if>
        <xsl:value-of select="." />
        <xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if>
      </xsl:for-each>
    </xsl:if>
    
    <xsl:variable name="different_source_name">
      <xsl:if test="$display_symbol=$lrg_gene_name and $gene_symbol_source!=$symbol_source">
        <xsl:if test="$gene_symbol or $gene_synonym"><xsl:text>, </xsl:text></xsl:if>
        <xsl:value-of select="$display_symbol"/>
      </xsl:if>
    </xsl:variable>
    <xsl:value-of select="$different_source_name"/>
    
    <xsl:if test="not($gene_symbol) and not($gene_synonym) and not($different_source_name)">-</xsl:if>

        <br/>
        <strong>LRG coords: </strong>
    <xsl:value-of select="$lrg_start"/>-<xsl:value-of select="$lrg_end"/>, 
    <xsl:choose>
      <xsl:when test="$lrg_strand >= 0">
          forward
      </xsl:when>
      <xsl:otherwise>
          reverse
      </xsl:otherwise>
    </xsl:choose>
          strand<br/>
            
<!-- Grab all db_xrefs from the gene, transcripts and proteins and filter out the ones that will not be displayed here -->
<!-- Skip the sources that are repeated (e.g. GeneID) -->
    <xsl:variable name="xref-list" select="db_xref[not(@source='GeneID')]|transcript/db_xref[not(@source='GeneID')]|transcript/protein_product/db_xref[not(@source='GeneID')]"/>
          <strong>External identifiers:</strong>
      <ul class="ext_id">
    <xsl:for-each select="$xref-list">
      <xsl:choose>
        <xsl:when test="@source='GeneID' or @source='HGNC' or @source='Ensembl' or @source='RFAM' or @source='miRBase' or @source='pseudogene.org'">
          <li><xsl:apply-templates select="."/></li>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
    
<!-- Finally, display the first element of repeated sources -->
    <xsl:for-each select="db_xref[@source='GeneID']|transcript/db_xref[@source='GeneID']|transcript/protein_product/db_xref[@source='GeneID']">
      <xsl:if test="position()=1">
         <li><xsl:apply-templates select="."/></li>
      </xsl:if>
    </xsl:for-each>
      </ul>
<!-- Mapping link only if the gene name corresponds to the LRG gene name -->
    <xsl:if test="$display_symbol=$lrg_gene_name and $gene_symbol_source=$symbol_source">
      <strong>Mappings: </strong>
      <a>
        <xsl:attribute name="href">
          <xsl:value-of select="$mapping_anchor"/>
        </xsl:attribute>
        Detailed mapping of transcripts to LRG
      </a>
    </xsl:if>
        
    <xsl:if test="comment">
          <strong>Comments: </strong>
      <xsl:for-each select="comment">
        <xsl:value-of select="."/>
        <xsl:if test="position()!=last()"><br/></xsl:if>
      </xsl:for-each>
    </xsl:if>
    
    <xsl:if test="$source=$ensembl_source_name and $display_symbol=$lrg_gene_name and $gene_symbol_source=$symbol_source">
      <div style="margin-top:6px">
        <xsl:call-template name="right_arrow_green" />
        <a target="_blank">
          <xsl:attribute name="class">icon-external-link</xsl:attribute>
          <xsl:attribute name="href"><xsl:value-of select="$ensembl_root_url" />Gene/Phenotype?g=<xsl:value-of select="$accession" /></xsl:attribute>Link to the Gene Phenotype page in Ensembl
        </a>
      </div>
    </xsl:if>
    
        </p>
         
<!--Transcripts-->
    </div>
    <div class="right_annotation">
      
    <xsl:choose>
      <xsl:when test="transcript">
        
        <table class="table bordered" style="width:100%;padding:0px;margin:0px">
          <thead>
            <tr class="gradient_color2">
              <th style="width:14%">Transcript ID</th>
              <th style="width:7%">Source</th>
              <th style="width:7%">Start</th>
              <th style="width:7%">End</th>
              <th style="width:20%">External identifiers</th>
              <th style="width:6%">LRG</th>
              <th style="width:39%px">Other</th>
            </tr>
          </thead>
          <tbody>
        <xsl:for-each select="transcript">
          <xsl:call-template name="updatable_transcript">
            <xsl:with-param name="lrg_id"><xsl:value-of select="$lrg_id" /></xsl:with-param>
            <xsl:with-param name="setnum"><xsl:value-of select="$setnum" /></xsl:with-param>
            <xsl:with-param name="gene_idx"><xsl:value-of select="$gene_idx" /></xsl:with-param>
            <xsl:with-param name="transcript_idx"><xsl:value-of select="position()" /></xsl:with-param>
          </xsl:call-template>
        </xsl:for-each>
          </tbody>
        <xsl:choose>
          <xsl:when test="transcript[protein_product]">
          <thead>
            <tr class="gradient_color2">
              <th>Protein ID</th>
              <th>Source</th>
              <th>CDS start</th>
              <th>CDS end</th>
              <th>External identifiers</th>
              <th>LRG</th>
              <th>Other</th>
            </tr>
          </thead>
          <tbody>
            <xsl:for-each select="transcript">
              <xsl:variable name="transcript_idx" select="position()"/>
              <xsl:for-each select="protein_product">
                <xsl:call-template name="updatable_protein">
                  <xsl:with-param name="lrg_id"><xsl:value-of select="$lrg_id" /></xsl:with-param>
                  <xsl:with-param name="setnum"><xsl:value-of select="$setnum" /></xsl:with-param>
                  <xsl:with-param name="gene_idx"><xsl:value-of select="$gene_idx" /></xsl:with-param>
                  <xsl:with-param name="transcript_idx"><xsl:value-of select="$transcript_idx" /></xsl:with-param>
                </xsl:call-template>
              </xsl:for-each>
            </xsl:for-each>
          </tbody>
          </xsl:when>
          <xsl:otherwise>
            <tr>
              <th colspan="6" class="no_data">No protein product identified for this gene in this source</th>
            </tr>
          </xsl:otherwise>
        </xsl:choose>
            <tr><td colspan="6" class="legend">> Click on a transcript/protein to highlight the transcript and protein pair</td></tr>
          
        </table>

     </xsl:when>
     <xsl:otherwise><div class="no_data"><br />No transcript identified for this gene in this source</div></xsl:otherwise>
    </xsl:choose>
    </div>
    <div style="clear:both" />
</xsl:template>


<!-- UPDATABLE TRANSCRIPT -->
<xsl:template name="updatable_transcript">
  <xsl:param name="lrg_id" />
  <xsl:param name="setnum" />
  <xsl:param name="gene_idx" />
  <xsl:param name="transcript_idx" />


  <xsl:variable name="lrg_start_a" select="coordinates[@coord_system = $lrg_coord_system]/@start" />
  <xsl:variable name="lrg_end_a" select="coordinates[@coord_system = $lrg_coord_system]/@end" />
   <xsl:variable name="lrg_start_b" select="coordinates[@coord_system = 'LRG']/@start" />
  <xsl:variable name="lrg_end_b" select="coordinates[@coord_system = 'LRG']/@end" />
  
  <xsl:variable name="lrg_start"><xsl:value-of select="$lrg_start_a"/><xsl:value-of select="$lrg_start_b"/></xsl:variable>
  <xsl:variable name="lrg_end"><xsl:value-of select="$lrg_end_a"/><xsl:value-of select="$lrg_end_b"/></xsl:variable>

  <tr valign="top">
  <xsl:attribute name="class">trans_prot</xsl:attribute>
  <xsl:attribute name="id">up_trans_<xsl:value-of select="$setnum"/>_<xsl:value-of select="$gene_idx"/>_<xsl:value-of select="$transcript_idx"/></xsl:attribute>
  <xsl:attribute name="onClick">toggle_transcript_highlight(<xsl:value-of select="$setnum"/>,<xsl:value-of select="$gene_idx"/>,<xsl:value-of select="$transcript_idx"/>)</xsl:attribute>
    <td>
  <xsl:choose>
    <xsl:when test="@source='RefSeq' or @source='Ensembl'">
      <span class="external_link"><xsl:value-of select="@accession"/></span>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="@accession"/>
    </xsl:otherwise>
  </xsl:choose>
    </td>
    <td><xsl:value-of select="@source"/></td>
    <td class="text_right"><xsl:value-of select="$lrg_start"/></td>
    <td class="text_right"><xsl:value-of select="$lrg_end"/></td>
    <td>
  <xsl:for-each select="db_xref|protein_product/db_xref">
    <xsl:choose>
      <xsl:when test="(@source='RefSeq' and substring(@accession,1,2)='NM') or @source='CCDS'">
        <xsl:apply-templates select="."/>
        <xsl:if test="position()!=last()">
      <br/>
        </xsl:if>
      </xsl:when>
    </xsl:choose>
  </xsl:for-each>   
    </td>
    <td>
      <xsl:choose>
       <xsl:when test="@fixed_id">
         <a>
           <xsl:attribute name="href">#transcript_<xsl:value-of select="@fixed_id"/></xsl:attribute>
           <xsl:value-of select="@fixed_id"/>
         </a>
       </xsl:when>
       <xsl:otherwise>-</xsl:otherwise>
     </xsl:choose>
    </td>
    <td>
  <xsl:if test="long_name">
      <strong>Name: </strong><xsl:value-of select="long_name"/><br/>
  </xsl:if>
  <xsl:for-each select="comment">
    <xsl:if test="string-length(.) &gt; 0">
      <strong>Comment: </strong><span class="external_link"><xsl:value-of select="."/></span><br/>
    </xsl:if>
  </xsl:for-each>
  <xsl:if test="@fixed_id">
     <strong>Comment: </strong>
     <xsl:choose>
       <xsl:when test="@source='Ensembl'">This transcript is identical to </xsl:when>
       <xsl:otherwise>This transcript was used for </xsl:otherwise>
     </xsl:choose>
      <a>
    <xsl:attribute name="href">#transcript_<xsl:value-of select="@fixed_id"/></xsl:attribute>
        LRG transcript <xsl:value-of select="@fixed_id"/>
      </a>
      <br/>
  </xsl:if>
  <xsl:if test="partial">
    <xsl:for-each select="partial">
      <strong>Note: </strong>
      <xsl:value-of select="."/> end of this transcript lies outside of the LRG<br/>  
    </xsl:for-each>
  </xsl:if>
    </td>
  </tr>
  
</xsl:template>
      
<!-- UPDATABLE PROTEIN ANNOTATION -->                 
<xsl:template name="updatable_protein">
  <xsl:param name="lrg_id" />
  <xsl:param name="setnum" />
  <xsl:param name="gene_idx" />
  <xsl:param name="transcript_idx" />

  <xsl:variable name="ncbi_url"><xsl:value-of select="$ncbi_root_url"/>protein/</xsl:variable>
  <xsl:variable name="ensembl_url"><xsl:value-of select="$ensembl_root_url"/>Transcript/ProteinSummary?db=core;protein=</xsl:variable>

  <xsl:variable name="lrg_start_a" select="coordinates[@coord_system = $lrg_coord_system]/@start" />
  <xsl:variable name="lrg_end_a" select="coordinates[@coord_system = $lrg_coord_system]/@end" />
   <xsl:variable name="lrg_start_b" select="coordinates[@coord_system = 'LRG']/@start" />
  <xsl:variable name="lrg_end_b" select="coordinates[@coord_system = 'LRG']/@end" />
  
  <xsl:variable name="lrg_start"><xsl:value-of select="$lrg_start_a"/><xsl:value-of select="$lrg_start_b"/></xsl:variable>
  <xsl:variable name="lrg_end"><xsl:value-of select="$lrg_end_a"/><xsl:value-of select="$lrg_end_b"/></xsl:variable>

  <tr valign="top">
  <xsl:attribute name="class">trans_prot</xsl:attribute>
  <xsl:attribute name="id">up_prot_<xsl:value-of select="$setnum"/>_<xsl:value-of select="$gene_idx"/>_<xsl:value-of select="$transcript_idx"/></xsl:attribute>
  <xsl:attribute name="onClick">toggle_transcript_highlight(<xsl:value-of select="$setnum"/>,<xsl:value-of select="$gene_idx"/>,<xsl:value-of select="$transcript_idx"/>)</xsl:attribute> 
    <td>
  <xsl:choose>
    <xsl:when test="@source='RefSeq' or @source='Ensembl'">
      <a>
      <xsl:attribute name="class">icon-external-link</xsl:attribute>
      <xsl:attribute name="target">_blank</xsl:attribute>
      <xsl:attribute name="href">
        <xsl:choose>
          <xsl:when test="@source='RefSeq'">
            <xsl:value-of select="$ncbi_url" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$ensembl_url" />
          </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="@accession"/>
      </xsl:attribute>
      <xsl:value-of select="@accession"/>
      </a>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="@accession"/>
    </xsl:otherwise>
  </xsl:choose>
    </td>
    <td><xsl:value-of select="@source"/></td>
    <td class="text_right"><xsl:value-of select="$lrg_start"/></td>
    <td class="text_right"><xsl:value-of select="$lrg_end"/></td>
    <td>
  <xsl:for-each select="db_xref[(@source='RefSeq' and substring(@accession,1,2)='NP') or @source='GI' or @source='UniProtKB']">
    <xsl:apply-templates select="."/>
    <xsl:if test="position()!=last()">
      <br/>
    </xsl:if>
  </xsl:for-each>   
    </td>
    <td>
      <xsl:choose>
        <xsl:when test="@fixed_id"> 
          <a>
            <xsl:attribute name="href">#transcript_t<xsl:value-of select="$transcript_idx"/></xsl:attribute>
            <xsl:value-of select="@fixed_id"/>
          </a>
        </xsl:when>
        <xsl:otherwise>-</xsl:otherwise>
      </xsl:choose>
    </td>
    <td>
  <xsl:if test="long_name">
      <strong>Name: </strong><xsl:value-of select="long_name"/><br/>
  </xsl:if>
  <xsl:for-each select="comment">
      <strong>Comment: </strong><xsl:value-of select="."/><br/>
  </xsl:for-each>
  <xsl:if test="@fixed_id">
      <strong>Comment: </strong>This protein was used for 
      <a>
    <xsl:attribute name="href">#transcript_t<xsl:value-of select="$transcript_idx"/></xsl:attribute>
        LRG protein <xsl:value-of select="@fixed_id"/>
      </a>
      <br/>
  </xsl:if>
  <xsl:if test="partial">
    <xsl:for-each select="partial">
      <xsl:variable name="part" select="." />
      <strong>Note: </strong>
      <xsl:choose>
        <xsl:when test="substring($part,1,1)='5'">
      N-terminal
        </xsl:when>
        <xsl:otherwise>
      C-terminal
        </xsl:otherwise>
      </xsl:choose>
      of this protein lies outside of the LRG<br/>  
    </xsl:for-each>
  </xsl:if>
    </td>
  </tr>

</xsl:template>

<xsl:template name="tokenize_str">
  <xsl:param name="input_str" />
  <xsl:param name="delimiter" select="' '" />
  
  <xsl:choose>
    <xsl:when test="$delimiter and contains($input_str,$delimiter)">
      <xsl:element name="token">
        <xsl:value-of select="substring-before($input_str, $delimiter)" />
      </xsl:element>
      <xsl:call-template name="tokenize_str">
        <xsl:with-param name="input_str" select="substring-after($input_str, $delimiter)" />
        <xsl:with-param name="delimiter" select="$delimiter" />
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:element name="token">
        <xsl:value-of select="$input_str" />
      </xsl:element>
    </xsl:otherwise>
  </xsl:choose>
  
</xsl:template>

<xsl:template name="format_date">
  <xsl:param name="date2format" />

  <xsl:variable name="delimiter">-</xsl:variable>

  <xsl:variable name="year"><xsl:value-of select="substring-before($date2format, $delimiter)" /></xsl:variable>
  <xsl:variable name="month_day"><xsl:value-of select="substring-after($date2format, $delimiter)" /></xsl:variable>

  <xsl:variable name="month"><xsl:value-of select="substring-before($month_day, $delimiter)" /></xsl:variable>
  <xsl:variable name="day"><xsl:value-of select="substring-after($month_day, $delimiter)" /></xsl:variable>
  
    <xsl:value-of select="$day"/>/<xsl:value-of select="$month"/>/<xsl:value-of select="$year"/>

</xsl:template>


<!-- DIFF -->
<xsl:template name="diff_table">
  <xsl:choose>
    <xsl:when test="count(diff) > 0">
      <td style="padding:0px">
        <table class="table table-hover bordered diff">
          <thead>
            <tr class="dark_blue" >
              <th class="no_border_left">Type</th>
              <th title="Reference coordinates">Ref. coord.</th>
              <th title="Reference allele">Ref. al.</th>
              <th></th>
              <th title="LRG allele">LRG al.</th>
              <th title="LRG coordinates">LRG coord.</th>
              <th title="HGVS notation on genomic reference sequence">Ref. HGVS</th>
              <th title="HGVS notation on LRG sequence">LRG HGVS</th>
              <th class="no_border_right" title="Display whether the difference falls into an exon, by transcript">in exon</th>
            </tr>
          </thead>
          <tbody>
          <xsl:for-each select="diff">
            <tr>
              <td class="no_border_bottom no_border_left" style="font-weight:bold">
                <xsl:variable name="diff_type" select="@type" />
                <xsl:choose>
                  <xsl:when test="$diff_type='lrg_ins'">
                    insertion
                  </xsl:when>
                  <xsl:when test="$diff_type='other_ins'">
                    deletion
                  </xsl:when>
                  <xsl:otherwise><xsl:value-of select="$diff_type" /></xsl:otherwise>
                </xsl:choose>
              </td>
              <td class="no_border_bottom text_right"><xsl:value-of select="@other_start"/><xsl:if test="@other_start != @other_end">-<xsl:value-of select="@other_end"/></xsl:if></td>
              <td class="text_right no_border_bottom" style="font-weight:bold">
                <xsl:choose>
                  <xsl:when test="@other_sequence"><xsl:value-of select="@other_sequence"/></xsl:when>
                  <xsl:otherwise>-</xsl:otherwise>
                </xsl:choose>
              </td>
            
              <td class="no_border_bottom">
                <xsl:call-template name="right_arrow_green">
                  <xsl:with-param name="no_margin">1</xsl:with-param>
                </xsl:call-template>
              </td>
              <td class="no_border_bottom" style="font-weight:bold">
                <xsl:choose>
                  <xsl:when test="@lrg_sequence"><xsl:value-of select="@lrg_sequence"/></xsl:when>
                  <xsl:otherwise>-</xsl:otherwise>
                </xsl:choose>
              </td>
              <td class="no_border_bottom text_right"><xsl:value-of select="@lrg_start"/><xsl:if test="@lrg_start != @lrg_end">-<xsl:value-of select="@lrg_end"/></xsl:if></td>

                <!--HGVS assembly -->
                <xsl:variable name="hgvs_assembly">
                  <xsl:choose>
                    <xsl:when test="contains(../../@coord_system,$previous_assembly) or contains(../../@coord_system,$current_assembly)">  
                      <xsl:choose>
                        <xsl:when test="contains(../../@coord_system,$previous_assembly)"><xsl:value-of select="$previous_assembly"/></xsl:when>
                        <xsl:when test="contains(../../@coord_system,$current_assembly)"><xsl:value-of select="$current_assembly"/></xsl:when>
                      </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>none</xsl:otherwise>
                  </xsl:choose>
                </xsl:variable> 
                  
              <!--Reference genome HGVS -->
              <td class="no_border_bottom">
                <xsl:if test="contains(../../@coord_system,$previous_assembly) or contains(../../@coord_system,$current_assembly)">  
                  <!--ID / Key -->
                  <xsl:variable name="genkey">
                    <xsl:text>gen_</xsl:text><xsl:value-of select="@type"/>_<xsl:value-of select="@other_start"/>_<xsl:value-of select="@other_end"/>_<xsl:value-of select="$hgvs_assembly"/>
                  </xsl:variable>   
           
                  <xsl:call-template name="diff_hgvs_genomic_ref">
                    <xsl:with-param name="chr"><xsl:value-of select="../../@other_name"/></xsl:with-param>
                    <xsl:with-param name="strand"><xsl:value-of select="../@strand"/></xsl:with-param>
                    <xsl:with-param name="assembly"><xsl:value-of select="$hgvs_assembly"/></xsl:with-param>
                    <xsl:with-param name="key"><xsl:value-of select="$genkey"/></xsl:with-param>
                  </xsl:call-template>
                </xsl:if>
              </td>
              <!--LRG HGVS -->
              <td class="no_border_bottom">
                 <!--ID / Key -->
                <xsl:variable name="lrgkey">
                  <xsl:text>lrg_</xsl:text><xsl:value-of select="@type"/>_<xsl:value-of select="@lrg_start"/>_<xsl:value-of select="@lrg_end"/>_<xsl:value-of select="$hgvs_assembly"/>
                </xsl:variable>
                <xsl:call-template name="diff_hgvs_genomic_lrg">
                  <xsl:with-param name="assembly"><xsl:value-of select="$hgvs_assembly"/></xsl:with-param>
                  <xsl:with-param name="key"><xsl:value-of select="$lrgkey"/></xsl:with-param>
                </xsl:call-template>
              </td>
              <td class="no_border_bottom no_border_right">
                <xsl:call-template name="diff_in_exon">
                  <xsl:with-param name="diff_start"><xsl:value-of select="@lrg_start"/></xsl:with-param>
                  <xsl:with-param name="diff_end"><xsl:value-of select="@lrg_end"/></xsl:with-param>
                </xsl:call-template>
              </td>
            </tr>
          </xsl:for-each>
        </tbody>  
      </table>  
    </td>
    </xsl:when>
    <xsl:otherwise><td><span style="color:#888">none</span></td></xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- HGVS genomic ref diff -->
<xsl:template name="diff_hgvs_genomic_ref">
  <xsl:param name="chr" />
  <xsl:param name="strand" />
  <xsl:param name="assembly" />
  <xsl:param name="key" />
  
  <xsl:variable name="hgvs_type">:g.</xsl:variable>
  
  <xsl:for-each select=".">
    <xsl:variable name="lrg_seq">
      <xsl:choose>
        <xsl:when test="$strand=1"><xsl:value-of select="@lrg_sequence"/></xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="reverse">
            <xsl:with-param name="input" select="@lrg_sequence"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="ref_seq">
      <xsl:choose>
        <xsl:when test="$strand=1"><xsl:value-of select="@other_sequence"/></xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="reverse">
            <xsl:with-param name="input" select="@other_sequence"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:variable name="diff">
    <xsl:choose>
      <!-- Ref deletion -->
      <xsl:when test="@type='lrg_ins'">
        <xsl:value-of select="@other_start"/>_<xsl:value-of select="@other_end"/>ins<xsl:value-of select="$lrg_seq"/>
      </xsl:when>
      <!-- Ref insertion -->
      <xsl:when test="@type='other_ins'">
        <xsl:choose>
          <xsl:when test="@other_start=@other_end">
            <xsl:value-of select="@other_start"/>del<xsl:value-of select="$ref_seq"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="@other_start"/>_<xsl:value-of select="@other_end"/>del<xsl:value-of select="$ref_seq"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <!-- Ref mismatch -->
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="@other_start=@other_end">
            <xsl:value-of select="@other_start"/><xsl:value-of select="$ref_seq"/>><xsl:value-of select="$lrg_seq"/>
          </xsl:when>  
          <xsl:otherwise>
            <xsl:value-of select="@other_start"/>_<xsl:value-of select="@other_end"/>del<xsl:value-of select="$ref_seq"/>ins<xsl:value-of select="$lrg_seq"/>
          </xsl:otherwise>
        </xsl:choose>  
      </xsl:otherwise>
    </xsl:choose>
    </xsl:variable>
    
    <div class="clearfix">
      <div style="float:left">
        <span class="blue" style="vertical-align:middle"><xsl:value-of select="$chr"/></span>
        <span style="color:#000;vertical-align:middle"><xsl:value-of select="$hgvs_type"/><xsl:value-of select="$diff"/></span>
      </div>
      <div style="float:right">
        <a class="vep_icon" data-toggle="tooltip" data-placement="bottom">
          <xsl:attribute name="href">
            <xsl:value-of select="$vep_parser_url"/><xsl:text>assembly=</xsl:text><xsl:value-of select="$assembly"/><xsl:text>&amp;hgvs=</xsl:text><xsl:value-of select="$chr"/><xsl:value-of select="$hgvs_type"/><xsl:value-of select="$diff"/>
          </xsl:attribute>
          <xsl:attribute name="target">_blank</xsl:attribute>
          <xsl:attribute name="id"><xsl:value-of select="$key"/></xsl:attribute>
          <xsl:attribute name="title">Click on the link above to see the VEP output for <xsl:value-of select="$chr"/><xsl:value-of select="$hgvs_type"/><xsl:value-of select="$diff"/></xsl:attribute>
        </a>
      </div>
    </div>  
  </xsl:for-each>
   
</xsl:template>


<!-- HGVS genomic diff lrg -->
<xsl:template name="diff_hgvs_genomic_lrg">
  <xsl:param name="assembly" />
  <xsl:param name="key" />

  <xsl:variable name="hgvs_type">:g.</xsl:variable>
  
  <xsl:for-each select=".">
    <xsl:variable name="diff">
    <xsl:choose>
      <!-- LRG insertion -->
      <xsl:when test="@type='lrg_ins'">
        <xsl:choose>
          <xsl:when test="@lrg_start=@lrg_end">
            <xsl:value-of select="@lrg_start"/>del<xsl:value-of select="@lrg_sequence"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="@lrg_start"/>_<xsl:value-of select="@lrg_end"/>del<xsl:value-of select="@lrg_sequence"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <!-- LRG deletion -->
      <xsl:when test="@type='other_ins'">
        <xsl:value-of select="@lrg_start"/>_<xsl:value-of select="@lrg_end"/>ins<xsl:value-of select="@other_sequence"/>
      </xsl:when>
      <!-- LRG mismatch -->
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="@lrg_start=@lrg_end">
            <xsl:value-of select="@lrg_start"/><xsl:value-of select="@lrg_sequence"/>><xsl:value-of select="@other_sequence"/>
          </xsl:when>  
          <xsl:otherwise>
            <xsl:value-of select="@lrg_start"/>_<xsl:value-of select="@lrg_end"/>del<xsl:value-of select="@lrg_sequence"/>ins<xsl:value-of select="@other_sequence"/>
          </xsl:otherwise>
        </xsl:choose>  
      </xsl:otherwise>
    </xsl:choose>
    </xsl:variable>
    <div class="clearfix">
      <div style="float:left">
        <span class="green" style="vertical-align:middle"><xsl:value-of select="$lrg_id"/></span>
        <span style="color:#000;vertical-align:middle"><xsl:value-of select="$hgvs_type"/><xsl:value-of select="$diff"/></span>
      </div>
    <xsl:if test="$assembly!='none' and $lrg_status=0">
      <div style="float:right">
        <a class="vep_icon vep_lrg" data-toggle="tooltip" data-placement="bottom">
          <xsl:attribute name="href">
            <xsl:value-of select="$vep_parser_url"/><xsl:text>assembly=</xsl:text><xsl:value-of select="$assembly"/><xsl:text>&amp;hgvs=</xsl:text><xsl:value-of select="$lrg_id"/><xsl:value-of select="$hgvs_type"/><xsl:value-of select="$diff"/>
          </xsl:attribute>
          <xsl:attribute name="target">_blank</xsl:attribute>
          <xsl:attribute name="id"><xsl:value-of select="$key"/></xsl:attribute>
          <xsl:attribute name="title">Click on the link above to see the VEP output for <xsl:value-of select="$lrg_id"/><xsl:value-of select="$hgvs_type"/><xsl:value-of select="$diff"/></xsl:attribute>
        </a>
      </div>
    </xsl:if>
    </div>
  </xsl:for-each>
   
</xsl:template>


<!-- Exon diff -->
<xsl:template name="diff_in_exon">
   <xsl:param name="diff_start" />
   <xsl:param name="diff_end" />
   <xsl:for-each select="/lrg/fixed_annotation/transcript">
     <xsl:variable name="transname" select="@name"/>
     <xsl:if test="position()!=1"><br /></xsl:if>
     <a>
       <xsl:attribute name="href">#transcript_<xsl:value-of select="$transname"/></xsl:attribute>
       <xsl:value-of select="$transname"/>
     </a>: 
     <xsl:variable name="exon_number">
       <xsl:for-each select="exon">
         <xsl:if test="coordinates[@coord_system=$lrg_id and @start &lt;= $diff_start and @end &gt;= $diff_start] or
         coordinates[@coord_system=$lrg_id and @start &lt;= $diff_end and @end &gt;= $diff_end]"><xsl:value-of select="@label"/></xsl:if>
       </xsl:for-each>
     </xsl:variable>


     <xsl:choose>
       <xsl:when test="$exon_number != ''">
         exon <xsl:value-of select="$exon_number"/>


         <!-- Check wether the diff is falling into a UTR or in a non coding exon -->
         <xsl:variable name="cds_start" select="coding_region/coordinates/@start" />
         <xsl:variable name="cds_end" select="coding_region/coordinates/@end" />
         <xsl:variable name="cdna_coord_system" select="concat($lrg_id,$transname)" />
         <xsl:variable name="peptide_coord_system" select="translate($cdna_coord_system,'t','p')" />
         <xsl:for-each select="exon[@label=$exon_number]">
           <xsl:variable name="lrg_start" select="coordinates[@coord_system = $lrg_coord_system]/@start" />
           <xsl:variable name="lrg_end" select="coordinates[@coord_system = $lrg_coord_system]/@end" />
           <xsl:variable name="peptide_start" select="coordinates[@coord_system = $peptide_coord_system]/@start"/>

           <xsl:choose>
             <!-- Coding exon -->
             <xsl:when test="$peptide_start">
               <xsl:choose>
                 <xsl:when test="$diff_start &gt;= $lrg_start and $diff_start &lt;= $cds_start"> (UTR)</xsl:when>
                 <xsl:when test="$diff_end &gt;= $lrg_start and $diff_end &lt;= $cds_start"> (UTR)</xsl:when>
                 <xsl:when test="$diff_start &lt;= $lrg_end and $diff_start &gt;= $cds_end"> (UTR)</xsl:when>
                 <xsl:when test="$diff_end &lt;= $lrg_end and $diff_end &gt;= $cds_end"> (UTR)</xsl:when>
               </xsl:choose>
             </xsl:when>
             <!-- Non coding exon -->
             <xsl:otherwise> (non coding)</xsl:otherwise>
           </xsl:choose>        
 
         </xsl:for-each>
       </xsl:when>
       <xsl:otherwise>no</xsl:otherwise>
     </xsl:choose>
   </xsl:for-each>
</xsl:template>


<xsl:template name="reverse">
  <xsl:param name="input"/>
  <xsl:variable name="len" select="string-length($input)"/>
  <xsl:choose>
    <!-- Strings of length less than 2 are trivial to reverse -->
    <xsl:when test="$len &lt; 2">
      <xsl:call-template name="complement">
        <xsl:with-param name="nt" select="$input"/>
      </xsl:call-template>
      <!--<xsl:value-of select="$input"/>-->
    </xsl:when>
    <!-- Strings of length 2 are also trivial to reverse -->
    <xsl:when test="$len = 2">
      <xsl:call-template name="complement">
        <xsl:with-param name="nt" select="substring($input,2,1)"/>
      </xsl:call-template>
      <xsl:call-template name="complement">
        <xsl:with-param name="nt" select="substring($input,1,1)"/>
      </xsl:call-template>
      <!--<xsl:value-of select="substring($input,2,1)"/>
      <xsl:value-of select="substring($input,1,1)"/>-->
    </xsl:when>
    <xsl:otherwise>
      <!-- Swap the recursive application of this template to the first half and second half of input -->
      <xsl:variable name="mid" select="floor($len div 2)"/>
      <xsl:call-template name="reverse">
        <xsl:with-param name="input" select="substring($input,$mid+1,$mid+1)"/>
      </xsl:call-template>
      <xsl:call-template name="reverse">
        <xsl:with-param name="input" select="substring($input,1,$mid)"/>
      </xsl:call-template>
    </xsl:otherwise>
     </xsl:choose>
</xsl:template>

<xsl:template name="complement">
  <xsl:param name="nt"/>
  <xsl:choose>
    <xsl:when test="$nt='A'">T</xsl:when>
    <xsl:when test="$nt='T'">A</xsl:when>  
    <xsl:when test="$nt='G'">C</xsl:when>
    <xsl:when test="$nt='C'">G</xsl:when> 
    <xsl:otherwise><xsl:value-of select="$nt"/></xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- FOOTER -->
<xsl:template name="footer">
    <footer>
      <div class="footer clearfix">
        <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6 text_right">
          <a href="http://www.ebi.ac.uk">
            <img alt="EMBL-EBI logo">
              <xsl:attribute name="src"><xsl:value-of select="$relative_path"/>img/embl-ebi_logo.png</xsl:attribute>
            </img>
          </a>
        </div>


        <div class="col-xs-6 col-sm-6 col-md-6 col-lg-6 text_left">
          <a>
            <xsl:attribute name="href"><xsl:value-of select="$ncbi_root_url"/></xsl:attribute>
            <img alt="NCBI logo">
              <xsl:attribute name="src"><xsl:value-of select="$relative_path"/>img/ncbi_logo.png</xsl:attribute>
            </img>
          </a>
        </div>

        <div class="col-lg-6 col-lg-offset-3 col-md-6 col-md-offset-3 col-sm-6 col-sm-offset-3 col-xs-6 col-xs-offset-3">
        <p>LRG 2016</p>
          <p class="footer-end">Site maintained by <a href="http://www.ebi.ac.uk/">EMBL-EBI</a> | <a href="http://www.ebi.ac.uk/Information/termsofuse.html">Terms of Use</a> | <a href="http://www.ebi.ac.uk/Information/privacy.html">Privacy</a> | <a href="http://www.ebi.ac.uk/Information/e-directive.html">Cookies</a></p>
        </div>
      </div>
    </footer>

</xsl:template>


<!-- ICONS DISPLAY -->  
<xsl:template name="lrg_logo">
  <img alt="LRG logo">
    <xsl:attribute name="src"><xsl:value-of select="$relative_path"/>img/lrg_logo.png</xsl:attribute>
  </img>
</xsl:template>

<xsl:template name="right_arrow_green">
  <xsl:param name="no_margin"/>
  <span>
    <xsl:choose>
      <xsl:when test="$no_margin">
        <xsl:attribute name="class">glyphicon glyphicon-circle-arrow-right green_button_0</xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="class">glyphicon glyphicon-circle-arrow-right green_button_4</xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
  </span>
</xsl:template>

<xsl:template name="lrg_right_arrow_green">
  <img alt="right_arrow">
    <xsl:attribute name="src"><xsl:value-of select="$relative_path"/>img/lrg_right_arrow_green.png</xsl:attribute>
  </img>
</xsl:template>

<xsl:template name="lrg_right_arrow_green_large">
  <img alt="right_arrow">
    <xsl:attribute name="src"><xsl:value-of select="$relative_path"/>img/lrg_right_arrow_green_large.png</xsl:attribute>
  </img>
</xsl:template>  

<xsl:template name="lrg_right_arrow_blue">
  <xsl:param name="img_id" />
  <img alt="right_arrow">
    <xsl:attribute name="src"><xsl:value-of select="$relative_path"/>img/lrg_right_arrow_blue.png</xsl:attribute>
    <xsl:if test="$img_id">
      <xsl:attribute name="id"><xsl:value-of select="$img_id" /></xsl:attribute>
    </xsl:if>
  </img>
</xsl:template>    

<xsl:template name="show_hide_button">
  <xsl:param name="div_id" />
  <span class="glyphicon glyphicon-plus-sign show_hide_button" title="Show/Hide data">
    <xsl:attribute name="id"><xsl:value-of select="$div_id"/>_button</xsl:attribute>
    <xsl:attribute name="onclick">javascript:showhide('<xsl:value-of select="$div_id"/>');</xsl:attribute>
  </span>
</xsl:template> 

<xsl:template name="hide_button">
  <xsl:param name="div_id" />
  <button type="button" class="btn btn-lrg">
    <xsl:attribute name="onclick">javascript:showhide('<xsl:value-of select="$div_id"/>');</xsl:attribute>
    <span class="glyphicon glyphicon-circle-arrow-up"></span> Hide
  </button>
</xsl:template> 

<xsl:template name="clear_exon_highlights">
  <xsl:param name="transname" />
  <div style="margin-top:5px">
    <button class="btn btn-lrg" type="button">
      <xsl:attribute name="onclick">javascript:clear_highlight('<xsl:value-of select="$transname"/>');</xsl:attribute>
      <span class="glyphicon glyphicon glyphicon-chevron-right"></span> Clear all the exon highlightings for the LRG transcript <xsl:value-of select="$transname"/>
    </button>
  </div>
</xsl:template>

<!-- Exon width - make sure we use at least 1 pixel to show the exon -->
<xsl:template name="exon_width">
  <xsl:param name="exon_width_percent" />
  <xsl:variable name="exon_width" select="floor($exon_width_percent * $image_width)"/>
  <xsl:choose>
    <xsl:when test="$exon_width &lt;= 0">1</xsl:when>
    <xsl:otherwise><xsl:value-of select="$exon_width" /></xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- Template to display labels-->
<xsl:template name="label">
  <xsl:param name="label" />
  <xsl:param name="desc" />
  <span class="label label-primary" data-toggle="tooltip" data-placement="right">
    <xsl:attribute name="title"><xsl:value-of select="$desc"/></xsl:attribute>
    <xsl:value-of select="$label"/>
  </span>
</xsl:template>

</xsl:stylesheet>


