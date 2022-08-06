<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs tei" version="2.0">

    <xsl:output method="xml" indent="no"/>

    <xsl:template match="@*|tei:*|text()" mode="RHrenameDivType">
        <xsl:copy>
            <xsl:apply-templates mode="RHrenameDivType" select="@*"/>
            <xsl:apply-templates mode="RHrenameDivType"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="tei:div/@type" mode="RHrenameDivType">
        <xsl:choose>
            <xsl:when test=".='Regest Deutsch'">
                <xsl:attribute name="type">regest_de</xsl:attribute>
            </xsl:when>
            <xsl:when test=".='Regest Englisch'">
                <xsl:attribute name="type">regest_en</xsl:attribute>
            </xsl:when>
            <xsl:when test=".='Archiv- und Druckvermerk'">
                <xsl:attribute name="type">archive_desc</xsl:attribute>
            </xsl:when>
            <!--            <xsl:when test=".='transcription'">
                <xsl:attribute name="type">transcription</xsl:attribute>
            </xsl:when>-->
            <xsl:when test=".='Kommentar'">
                <xsl:attribute name="type">commentary</xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


</xsl:stylesheet>