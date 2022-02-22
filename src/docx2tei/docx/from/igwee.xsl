<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:prop="http://schemas.openxmlformats.org/officeDocument/2006/custom-properties"
  xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
  xmlns:cp="http://schemas.openxmlformats.org/package/2006/metadata/core-properties"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:dcterms="http://purl.org/dc/terms/"
  xmlns:dcmitype="http://purl.org/dc/dcmitype/"
  xmlns:iso="http://www.iso.org/ns/1.0"
  xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math"
  xmlns:mml="http://www.w3.org/1998/Math/MathML"
  xmlns:mo="http://schemas.microsoft.com/office/mac/office/2008/main"
  xmlns:mv="urn:schemas-microsoft-com:mac:vml"
  xmlns:o="urn:schemas-microsoft-com:office:office"
  xmlns:pic="http://schemas.openxmlformats.org/drawingml/2006/picture"
  xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
  xmlns:rel="http://schemas.openxmlformats.org/package/2006/relationships"
  xmlns:tbx="http://www.lisa.org/TBX-Specification.33.0.html"
  xmlns:html="http://www.w3.org/1999/xhtml"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:teidocx="http://www.tei-c.org/ns/teidocx/1.0"
  xmlns:v="urn:schemas-microsoft-com:vml"
  xmlns:ve="http://schemas.openxmlformats.org/markup-compatibility/2006"
  xmlns:w10="urn:schemas-microsoft-com:office:word"
  xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
  xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml"
  xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing"
  xmlns:uibk="http://igwee.uibk.ac.at/custom/ns"
  
  xmlns="http://www.tei-c.org/ns/1.0"
  version="2.0">

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet" type="stylesheet">
      <desc>
         <p>CUSTOM Word-To-TEI Stylesheet (IGWEE)</p>
         <p>This software is dual-licensed:

1. Distributed under a Creative Commons Attribution-ShareAlike 3.0
Unported License http://creativecommons.org/licenses/by-sa/3.0/ 

2. http://www.opensource.org/licenses/BSD-2-Clause
		
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

* Redistributions of source code must retain the above copyright
notice, this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in the
documentation and/or other materials provided with the distribution.

This software is provided by the copyright holders and contributors
"as is" and any express or implied warranties, including, but not
limited to, the implied warranties of merchantability and fitness for
a particular purpose are disclaimed. In no event shall the copyright
holder or contributors be liable for any direct, indirect, incidental,
special, exemplary, or consequential damages (including, but not
limited to, procurement of substitute goods or services; loss of use,
data, or profits; or business interruption) however caused and on any
theory of liability, whether in contract, strict liability, or tort
(including negligence or otherwise) arising in any way out of the use
of this software, even if advised of the possibility of such damage.
</p>
         <p>Author: Joseph Wang</p>
         <p>Id: $Id$</p>
         <p>Copyright: 2014, Joseph Wang</p>
      </desc>
   </doc>

  <xsl:template match="w:commentRangeStart">
    <xsl:element name="uibk:comment">
      <xsl:attribute name="commentId" select="@w:id"></xsl:attribute>
      <xsl:attribute name="type">start</xsl:attribute>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="w:commentRangeEnd">
    <xsl:element name="uibk:comment">
      <xsl:attribute name="commentId" select="@w:id"></xsl:attribute>
      <xsl:attribute name="type">end</xsl:attribute>
    </xsl:element>
  </xsl:template>
  
<!--  <xsl:template match="w:commentReference" priority="100">
    <xsl:variable name="commentN" select="@w:id"/>
    <xsl:for-each
      select="document(concat($wordDirectory,'/word/comments.xml'))/w:comments/w:comment[@w:id=$commentN]">
      <note place="comment" resp="{translate(@w:author,' ','_')}" commentId="{@w:id}">
        <date when="{@w:date}"/>
        <xsl:apply-templates/>
      </note>
    </xsl:for-each>
  </xsl:template>
-->  
  <xsl:template match="tei:hi[@rend='annotation_reference']" mode="pass2" priority="100">
    <xsl:text>found</xsl:text>
    <xsl:apply-templates mode="pass2"></xsl:apply-templates>
  </xsl:template>
  

</xsl:stylesheet>
