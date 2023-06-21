<?xml version="1.0" encoding="UTF-8"?>
<!-- Stylesheet used to generate an XML from the JSON input -->
<xsl:stylesheet xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xpathf="http://www.w3.org/2005/xpath-functions"
    xmlns:functx="http://www.functx.com" version="3.0" exclude-result-prefixes="xsl tei xs xpathf functx">
    
    <xsl:output encoding="UTF-8" media-type="text" method="xml" version="1.0" indent="yes" omit-xml-declaration="yes"/>
    
    <!-- fetch geoname id -->    
    <xsl:function name="functx:add-geoname-id-reg" as="node()*"
        xmlns:functx="http://www.functx.com"
        xmlns:tei="http://www.tei-c.org/ns/1.0"
        xmlns:xpathf="http://www.w3.org/2005/xpath-functions">
        
        <xsl:param name="elements" as="node()"/><!-- var $json2xml -->        
        <xsl:param name="key" as="item()"/><!-- var @key -->
        
        <xsl:for-each select="$elements//xpathf:map[parent::xpathf:array]">            
            <xsl:if test="./xpathf:string[@key = 'key']/text() = $key">
                <xsl:value-of select="./xpathf:map[child::xpathf:string[@key = 'authority']/text() = 'GEO_NAMES']/xpathf:string[@key = 'id']/text()"/>    
            </xsl:if>   
        </xsl:for-each>        
    </xsl:function>
    
    <!-- input XML letter files -->
    <xsl:variable name="full_path">
        <xsl:value-of select="document-uri(/)"/>
    </xsl:variable>
    
    <xsl:variable name="coll" select="collection($full_path)"/>
    <!-- 
    <xsl:variable name="coll" select="document($full_path)"/>
    -->
    
    <!-- input JSON file -->
    <xsl:variable name="json" select="'../../data/json/map.json'"/>    
    <xsl:variable name="json2xml" select="json-to-xml(unparsed-text($json))"/>    
    
    <!-- make register -->    
    <xsl:variable name="tree">
        <TEI xmlns="http://www.tei-c.org/ns/1.0">
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title>Place Register in TEI generated from TEI data of letters</title>
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
                        <xsl:for-each-group select="$coll//tei:placeName" group-by="@key">
                            <xsl:sort select="@key" lang="de-de"/>
                            <xsl:variable name="normalizeGroup">
                                <xsl:for-each select="current-group()">                                            
                                    <p>
                                        <xsl:value-of select="normalize-space(.)"/>
                                    </p>
                                </xsl:for-each>    
                            </xsl:variable>
                            
                            <item>
                                <note type="place">
                                    <placeName n="place_{generate-id(@key)}">
                                        <xsl:value-of select="@key"/>
                                    </placeName>
                                </note>
                                <note type="geoname">
                                    <xsl:value-of select="functx:add-geoname-id-reg($json2xml, @key)"/>
                                </note>
                                <note type="gnd"></note>
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
    <!-- output JSON file -->
    <xsl:variable name="xml2json">
        <array xmlns="http://www.w3.org/2005/xpath-functions">            
            <xsl:for-each select="$tree//tei:item">
                <map>
                    <string key="geoname">
                        <xsl:value-of select="./tei:note[@type='geoname']"/>
                    </string>
                    <array key="writings">
                        <xsl:for-each select="./tei:note[@type='writings']/tei:p">                                
                            <string>
                                <xsl:value-of select="."/>
                            </string>
                        </xsl:for-each>                            
                    </array>
                </map>
            </xsl:for-each>                        
        </array>
    </xsl:variable>
    
    <!-- initial template -->
    <xsl:template match="/">
        <xsl:result-document href="../../data/register/tmp/jsonToXml.xml">
            <xsl:sequence select="$json2xml"/>
        </xsl:result-document>
        <xsl:call-template name="make_reg"/>
        <xsl:result-document href="../../data/json/register_place_writings.json">                        
            <xsl:value-of select="xml-to-json($xml2json)"/>
        </xsl:result-document>        
    </xsl:template>
    
    <!-- register template -->    
    <xsl:template name="make_reg" match="$tree">
        <xsl:sequence select="$tree"/>
    </xsl:template>
    
</xsl:stylesheet>
    