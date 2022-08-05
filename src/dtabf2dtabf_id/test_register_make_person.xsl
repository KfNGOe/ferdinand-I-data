<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet 
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:functx="http://www.functx.com"
    version="2.0" exclude-result-prefixes="xsl tei xs functx">
    
    <xsl:output encoding="UTF-8" media-type="text" method="xml" version="1.0" indent="yes" omit-xml-declaration="no"/>      
    
    <xsl:variable name="full_path">
        <xsl:value-of select="document-uri(/)"/>
    </xsl:variable>

    <xsl:variable name="coll" select="collection($full_path)"/>

    <xsl:variable name="TEI" select="//element()"></xsl:variable>

    
    <xsl:variable name="tree">
        <TEI xmlns="http://www.tei-c.org/ns/1.0">
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title>Person Register in TEI generated from TEI data of letters</title>
                    </titleStmt>
                    <publicationStmt>
                        <p>Publication Information</p>
                    </publicationStmt>
                    <sourceDesc>
                        <p>Information about the source</p>
                    </sourceDesc>
                </fileDesc>
            </teiHeader>
            <text>
                <body>
                    <list>
                        <xsl:for-each-group select="$coll//tei:persName" group-by="@key">                        
                            <xsl:sort select="@key"/>                            
                            
                            <item>
                                <note type="person">
                                    <persName xml:id="person_{generate-id(@key)}">
                                        <xsl:value-of select="@key"/>
                                    </persName>
                                </note>
                                <note type="writings">
                                    <xsl:for-each select="distinct-values(current-group())">
                                        <p><xsl:value-of select="normalize-space(.)"/></p>
                                    </xsl:for-each>
                                </note>                                
                                <note type="occurence">
                                    <xsl:for-each-group select="current-group()" group-by="//tei:fileDesc/tei:titleStmt/tei:title[@type='main']">
                                        <xsl:variable name="full_path">
                                            <xsl:value-of select="document-uri(/)"/>
                                        </xsl:variable>                               
                                        <p>
                                            <xsl:attribute name="source" select="tokenize($full_path, '/')[last()]"/>                                           
                                            <xsl:value-of select="//tei:fileDesc/tei:titleStmt/tei:title[@type='main']"/>
                                        </p>                                        
                                    </xsl:for-each-group>                                    
                                </note>                    
                            </item>
                            
                        </xsl:for-each-group>                                                
                    </list>
                </body>
            </text>
        </TEI>        
    </xsl:variable>
    
    <xsl:template match="/">
        
        <!--
        <xsl:result-document href="../../register/test_reg.xml" method="xml">
        -->    
        <xsl:call-template name="make_reg"></xsl:call-template>
        <!--     
        </xsl:result-document>        
        --> 
        
    </xsl:template>    
    
    <!-- make register -->
    
    <xsl:template name="make_reg" match="$tree">
        <xsl:sequence select="$tree"/>
    </xsl:template>         
    
</xsl:stylesheet>
