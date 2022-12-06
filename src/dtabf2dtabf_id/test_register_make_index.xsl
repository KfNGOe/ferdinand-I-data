<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:functx="http://www.functx.com" version="2.0" exclude-result-prefixes="xsl tei xs functx">
    
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
                        <title>Index Register in TEI generated from TEI data of letters</title>
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
                        <xsl:for-each-group select="$coll//tei:index/tei:term" group-by="@key">
                            <xsl:sort select="@key" lang="de-de"/>
                            <xsl:variable name="normalizeGroup">
                                <xsl:for-each select="current-group()">                                            
                                    <p>
                                        <xsl:value-of select="normalize-space(.)"/>
                                    </p>
                                </xsl:for-each>    
                            </xsl:variable>
                            
                            <item>
                                <note type="index">
                                    <index>
                                        <term xml:id="index_{generate-id(@key)}">
                                            <xsl:value-of select="@key"/>
                                        </term>
                                    </index>
                                </note>
                                <note type="writings">
                                    <xsl:for-each select="distinct-values($normalizeGroup/tei:p)">
                                        <xsl:sort select="." lang="de-de"/>
                                        <p>
                                            <xsl:value-of select="."/>
                                        </p>
                                    </xsl:for-each>
                                </note>
                                <note type="occurence">
                                    <xsl:for-each select="current-group()">
                                        <xsl:variable name="volume" select="tokenize(document-uri(/), '/')[last()-1]"/>
                                        <xsl:variable name="letter" select="tokenize(document-uri(/), '/')[last()]"/>
                                        <p>
                                            <xsl:attribute name="source" select="$letter"/>
                                            <val>
                                                <xsl:value-of select="replace(//tei:fileDesc/tei:titleStmt/tei:title[@type='main'],'\.','')"/>
                                            </val>
                                            <note type="volNr">
                                                <xsl:value-of select="replace(tokenize($volume, '_')[last()],'^0+','')"/>
                                            </note>
                                            <note type="div">
                                                <xsl:if test="./ancestor::tei:div/@n = 2">
                                                    <xsl:text>regest_de</xsl:text>
                                                </xsl:if>
                                                <xsl:if test="./ancestor::tei:div/@n = 3">
                                                    <xsl:text>regest_en</xsl:text>
                                                </xsl:if>
                                                <xsl:if test="./ancestor::tei:div/@n = 4">
                                                    <xsl:text>archive_desc</xsl:text>
                                                </xsl:if>
                                                <xsl:if test="./ancestor::tei:div/@n = 5">
                                                    <xsl:text>transcription</xsl:text>
                                                </xsl:if>
                                                <xsl:if test="./ancestor::tei:div/@n = 6">
                                                    <xsl:text>commentary</xsl:text>
                                                </xsl:if>
                                            </note>
                                            <note type="para">
                                                <xsl:choose>
                                                    <xsl:when test="exists(./ancestor::tei:table[parent::tei:div[@n='5']])">                                                        
                                                        <xsl:variable name="cell1Level1" select="./ancestor::tei:row/tei:cell[1]/text()[1]"/>                    
                                                        <xsl:variable name="cell2Level1" select="./ancestor::tei:row/tei:cell[2]/text()[1]"/>
                                                        <xsl:variable name="cell2Level2" select="./ancestor::tei:row/tei:cell[2]/*[1]/text()[1]"/>
                                                        
                                                        <xsl:choose>
                                                            <xsl:when test="exists($cell1Level1)">
                                                                <xsl:choose>
                                                                    <xsl:when test="matches($cell1Level1, '^\d+\]\s+')">
                                                                        <xsl:analyze-string select="$cell1Level1" regex="^(\d+)\]\s+">
                                                                            <xsl:matching-substring>
                                                                                <xsl:value-of select="regex-group(1)"/>
                                                                            </xsl:matching-substring>
                                                                        </xsl:analyze-string>
                                                                    </xsl:when>                                                                            
                                                                </xsl:choose>                                
                                                            </xsl:when>
                                                            <xsl:otherwise>                                                                
                                                                <xsl:choose>
                                                                    <xsl:when test="exists($cell2Level2)">
                                                                        <xsl:choose>
                                                                            <xsl:when test="matches($cell2Level2, '^\d+\]\s+')">
                                                                                <xsl:analyze-string select="$cell2Level2" regex="^(\d+)\]\s+">
                                                                                    <xsl:matching-substring>                                                                                        
                                                                                        <xsl:value-of select="regex-group(1)"/>
                                                                                    </xsl:matching-substring>                                                                                    
                                                                                </xsl:analyze-string>
                                                                            </xsl:when>                                                                            
                                                                        </xsl:choose>                                                
                                                                    </xsl:when>                                            
                                                                </xsl:choose>
                                                            </xsl:otherwise>
                                                        </xsl:choose>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <!-- find ancestor p -->                                                        
                                                        <xsl:variable name="ancestorP" select="./ancestor::tei:p[parent::tei:div]"/>
                                                        <!-- find self p -->
                                                        <xsl:variable name="selfP" select="$ancestorP/self::tei:p[@n]"/>
                                                        <!-- find sibling p -->
                                                        <xsl:variable name="siblingP" select="$ancestorP/preceding-sibling::tei:p[@n][1]"/>
                                                        <xsl:choose>
                                                            <xsl:when test="$selfP">
                                                                <xsl:value-of select="$selfP/@n"/>
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                <xsl:value-of select="$siblingP/@n"/>
                                                            </xsl:otherwise>
                                                        </xsl:choose>
                                                    </xsl:otherwise>
                                                </xsl:choose>                                                
                                            </note>
                                        </p>
                                    </xsl:for-each>
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
