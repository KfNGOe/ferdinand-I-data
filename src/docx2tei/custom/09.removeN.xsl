<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs tei" version="2.0">

    <xsl:output method="xml" indent="no"/>

    <xsl:template match="@*|tei:*|text()" mode="RHremoveN">
        <xsl:copy>
            <xsl:apply-templates mode="RHremoveN" select="@*"/>
            <xsl:apply-templates mode="RHremoveN"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="tei:p[@n]" mode="RHremoveN">
        <xsl:variable name="firstTextNodeId" select="generate-id((.//text())[1])"/>
        <xsl:copy>
            <xsl:apply-templates select="@*" mode="RHremoveN"/>
            <xsl:apply-templates mode="removeFirstNumber">
                <xsl:with-param name="replaceN" select="@n"/>
                <xsl:with-param name="replaceId" select="$firstTextNodeId"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="tei:*" mode="removeFirstNumber">
        <xsl:param name="replaceN"/>
        <xsl:param name="replaceId"/>
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates mode="removeFirstNumber">
                <xsl:with-param name="replaceN" select="$replaceN"/>
                <xsl:with-param name="replaceId" select="$replaceId"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="text()" mode="removeFirstNumber">
        <xsl:param name="replaceN"/>
        <xsl:param name="replaceId"/>
        <xsl:variable name="myId" select="generate-id(.)"/>
        <xsl:choose>
            <xsl:when test="$myId=$replaceId">
                <xsl:variable name="pattern">
                    <xsl:text>(</xsl:text>
                    <xsl:value-of select="$replaceN"/>
                    <xsl:text>\s*[\]\)])\s*(.*)</xsl:text>
                </xsl:variable>
                <xsl:value-of select="replace(., $pattern, '$2')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>