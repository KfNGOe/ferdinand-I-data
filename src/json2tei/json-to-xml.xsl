<?xml version="1.0" encoding="UTF-8"?>
<!-- Stylesheet used to generate an XML from the JSON input -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:f="http://www.w3.org/2005/xpath-functions"
    version="3.0" exclude-result-prefixes="xsl f">
    
    <xsl:output encoding="UTF-8" media-type="text" method="xml" version="1.0" indent="yes" omit-xml-declaration="yes"/>
        
    <!-- The input JSON file -->
    <xsl:variable name="json" select="'../../data/json/map.json'"/>
    <xsl:variable name="xml" select="json-to-xml(unparsed-text($json))"/>
    
    
    <!-- The initial template that process the JSON -->
    <xsl:template name="xsl:initial-template" match="/">
        <xsl:apply-templates select="$xml" mode="copy"/>
    </xsl:template>    
    
    <xsl:template match="node() | @*" mode="copy">        
            <xsl:apply-templates select="node() | @*" mode="copy"/>        
    </xsl:template>
        
    <xsl:template match="$xml/f:array" mode="copy">            
        <xsl:copy>            
            <xsl:apply-templates mode="copy"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="$xml//f:map[parent::f:array]" mode="copy">            
        <xsl:copy>            
            <xsl:apply-templates mode="copy"/>
        </xsl:copy>
    </xsl:template>
        
    <xsl:template match="$xml//f:string[@key = 'key']" mode="copy">            
        <xsl:copy>            
            <xsl:attribute name="key" select="./@key"/>
            <xsl:value-of select="."/>            
            <xsl:apply-templates mode="copy"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="$xml//f:map[@key = 'mappedTo']" mode="copy">            
        <xsl:copy>            
            <xsl:attribute name="key" select="./@key"/>
            <xsl:element name="string" namespace="http://www.w3.org/2005/xpath-functions">
                <xsl:attribute name="key" select="./f:string[@key = 'authority']/@key"/>
                <xsl:value-of select="./f:string[@key = 'authority']"/>
            </xsl:element>
            <xsl:element name="string" namespace="http://www.w3.org/2005/xpath-functions">
                <xsl:attribute name="key" select="./f:string[@key = 'id']/@key"/>
                <xsl:value-of select="./f:string[@key = 'id']"/>
            </xsl:element>                        
            <xsl:apply-templates mode="copy"/>
        </xsl:copy>
    </xsl:template>    
        
</xsl:stylesheet>

