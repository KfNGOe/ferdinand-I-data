<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:functx="http://www.functx.com"
    version="2.0" exclude-result-prefixes="xsl tei xs functx">

    <xsl:output encoding="UTF-8" media-type="text" method="xml" version="1.0" indent="yes" omit-xml-declaration="no"/>
        
    <xsl:function name="functx:add-id-person" as="node()*"
        xmlns:functx="http://www.functx.com"
        xmlns:tei="http://www.tei-c.org/ns/1.0">
        <xsl:param name="elements" as="node()"/> <!-- var $reg_ -->        
        <xsl:param name="key" as="item()"/> <!-- var @key -->
        
        <xsl:for-each select="$elements//tei:persName">            
            <xsl:if test=". = $key">
                <xsl:value-of select="./@xml:id"/>    
            </xsl:if>   
        </xsl:for-each>
        
    </xsl:function>

    <xsl:function name="functx:add-id-place" as="node()*"
        xmlns:functx="http://www.functx.com"
        xmlns:tei="http://www.tei-c.org/ns/1.0">
        <xsl:param name="elements" as="node()"/> <!-- var $reg_ -->        
        <xsl:param name="key" as="item()"/> <!-- var @key -->
        
        <xsl:for-each select="$elements//tei:placeName">            
            <xsl:if test=". = $key">
                <xsl:value-of select="./@xml:id"/>    
            </xsl:if>   
        </xsl:for-each>
        
    </xsl:function>
    
    <xsl:function name="functx:add-id-index" as="node()*"
        xmlns:functx="http://www.functx.com"
        xmlns:tei="http://www.tei-c.org/ns/1.0">
        <xsl:param name="elements" as="node()"/> <!-- var $reg_ -->        
        <xsl:param name="key" as="item()"/> <!-- var @key -->
        
        <xsl:for-each select="$elements//tei:term">            
            <xsl:if test=". = $key">
                <xsl:value-of select="./@xml:id"/>    
            </xsl:if>   
        </xsl:for-each>
        
    </xsl:function>
    
    <xsl:variable name="full_path">
        <xsl:value-of select="document-uri(/)"/>
    </xsl:variable>

    <xsl:variable name="coll" select="collection($full_path)"/>
        
    <xsl:variable name="TEI" select="//*"></xsl:variable>
    
    <xsl:variable name="reg_person" select="document('../../data/register/register_person.xml')"/>
    <xsl:variable name="reg_place" select="document('../../data/register/register_place.xml')"/>
    <xsl:variable name="reg_index" select="document('../../data/register/register_index.xml')"/>
    
    <xsl:template match="/">
        
        <xsl:for-each select="$coll">
            <xsl:if test="not(tokenize(document-uri(/), '/')[last()] = 'collection.xml')">
                <xsl:result-document href="../dtabf_id/band_001/{tokenize(document-uri(/), '/')[last()]}" method="xml">
                <xsl:call-template name="copy_tei"></xsl:call-template>
                </xsl:result-document>
            </xsl:if>
        </xsl:for-each>
        
    </xsl:template>
    
    <!-- copy tei -->    
    <xsl:template name="copy_tei" match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>                
    </xsl:template>
    
    <xsl:template match="tei:persName">        
        <xsl:element name="persName">
            <xsl:if test="exists(@key)">
                <xsl:attribute name="xml:id"                
                    select="functx:add-id-person($reg_person, @key)"/>
            </xsl:if>                      
            <xsl:apply-templates select="@*|node()"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:placeName">
        <xsl:element name="placeName">
            <xsl:if test="exists(@key)">
                <xsl:attribute name="xml:id"                
                    select="functx:add-id-place($reg_place, @key)"/>
            </xsl:if>                      
            <xsl:apply-templates select="@*|node()"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="tei:term">
        <xsl:element name="term">
            <xsl:if test="exists(@key)">
                <xsl:attribute name="xml:id"                
                    select="functx:add-id-index($reg_index, @key)"/>
            </xsl:if>                      
            <xsl:apply-templates select="@*|node()"/>
        </xsl:element>
    </xsl:template>
    
    
</xsl:stylesheet>
