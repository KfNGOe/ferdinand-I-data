<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:html="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xs tei html"
    version="2.0">
    
    <xsl:param name="filename">
       <xsl:call-template name="findFilename">
           <xsl:with-param name="uri" select="base-uri()"/>
       </xsl:call-template>
    </xsl:param>
    
    <xsl:output method="xml" indent="no" encoding="UTF-8" omit-xml-declaration="yes"/>
    
    
    <xsl:template match="/">
        <div class="text-justify">
            <h3><a id="letterTop" name="letterTop"/><xsl:call-template name="findTitle"/></h3>
            <hr/>
            <div class="text-center">
                <a href="laferl/xml/{$filename}.xml" target="_blank">xml</a> |
                <a href="laferl/docx/{$filename}.docx" target="_blank">docx</a>
            </div>
            <hr/>
            <h4>Metadaten</h4>
            <table class="table">
                <tbody>
                    <tr>
                        <td>Absender/in</td><td><xsl:call-template name="findSender"/></td>
                    </tr>
                    <tr>
                        <td>Empfänger/in</td><td><xsl:call-template name="findRecipient"/></td>
                    </tr>
                    <tr>
                        <td>Datierung</td><td><xsl:call-template name="findDating"/></td>
                    </tr>
                    <tr>
                        <td>Brief-ID</td><td><xsl:call-template name="findId"/></td>
                    </tr>
                    <tr>
                        <td>Personen-Verweise</td>
                        <td><xsl:call-template name="findPersNames"/></td>
                    </tr>
                    <tr>
                        <td>Ortsverweise</td><td><xsl:call-template name="findPlaceNames"/></td>
                    </tr>
                    <tr>
                        <td>Index-Einträge</td><td><xsl:call-template name="findIndexes"/></td>
                    </tr>
                </tbody>
            </table>
            <h4>Text</h4>
            <div>
                <xsl:apply-templates select="//tei:text"/>
            </div>
        </div>
    </xsl:template>
    
    
    <xsl:template match="tei:hi">
        <xsl:element name="span">
            <xsl:if test="@rend">
                <xsl:attribute name="style">
                    <xsl:call-template name="adjustHiRend">
                        <xsl:with-param name="rend" select="@rend"/>
                    </xsl:call-template>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="tei:div">
        <div>
            <xsl:if test="@rend">
                <xsl:attribute name="style">
                    <xsl:call-template name="adjustHiRend">
                        <xsl:with-param name="rend" select="@rend"/>
                    </xsl:call-template>
                </xsl:attribute>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="@type">
                    <xsl:choose>
                        <xsl:when test="@type='notRecognized'">
                            <xsl:attribute name="class">panel panel-danger</xsl:attribute>
                            <div class="panel-heading">Textstruktur nicht erkannt</div>
                            <div class="panel-body">
                                <xsl:apply-templates/>
                            </div>
                        </xsl:when>
                        <xsl:when test="@type='regesta'">
                            <xsl:attribute name="class">panel panel-default</xsl:attribute>
                            <div class="panel-heading">Regesten (Deutsch/Englisch), Archivvermerk, Überlieferung</div>
                            <div class="panel-body">
                                <xsl:apply-templates/>
                            </div>
                        </xsl:when>
                        <xsl:when test="@type='transcript'">
                            <xsl:attribute name="class">panel panel-warning</xsl:attribute>
                            <div class="panel-heading">Transkript</div>
                            <div class="panel-body">
                                <xsl:apply-templates/>
                            </div>
                        </xsl:when>
                        <xsl:when test="@type='notes'">
                            <xsl:attribute name="class">panel panel-warning</xsl:attribute>
                            <div class="panel-heading">Kommentar</div>
                            <div class="panel-body">
                                <xsl:apply-templates/>
                            </div>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="class">panel panel-default</xsl:attribute>
                            <div class="panel-body">
                                <xsl:apply-templates/>
                            </div>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:p">
        <div class="paragraph">
            <p>
                <xsl:if test="@rend">
                    <xsl:attribute name="style">
                        <xsl:call-template name="adjustHiRend">
                            <xsl:with-param name="rend" select="@rend"/>
                        </xsl:call-template>
                    </xsl:attribute>
                </xsl:if>
                <xsl:apply-templates/>
            </p>
            <xsl:if test=".//tei:note">
                <div class="notes">
                    <xsl:for-each select=".//tei:note">
                        <xsl:apply-templates select="." mode="note"/>
                    </xsl:for-each>
                </div>
            </xsl:if>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:seg[@rend]">
        <span>
            <xsl:attribute name="style">
                <xsl:call-template name="adjustHiRend">
                    <xsl:with-param name="rend" select="@rend"/>
                </xsl:call-template>
            </xsl:attribute>
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:note">
        <xsl:variable name="noteNum">
            <xsl:number count="//tei:note" level="any"/>
        </xsl:variable>
        <a href="#note_{$noteNum}" name="note_{$noteNum}_text"><span class="paragraphNoteNumber" style="font-size: 70%; vertical-align: top; background-color: #00FF00"><xsl:value-of select="$noteNum"/></span></a>
    </xsl:template>
    
    <xsl:template match="tei:note" mode="note">
        <xsl:variable name="noteNum">
            <xsl:number count="//tei:note" level="any"/>
        </xsl:variable>
        <table class="note" style="width:90%; font-size: smaller; margin-left: auto; margin-right: auto; text-align: left;">
            <tr style="vertical-align: top;">
                <td style="width: 5%; text-align: right; "><a href="#note_{$noteNum}_text" name="note_{$noteNum}"><xsl:value-of select="$noteNum"/></a></td>
                <td style="width: 95%; padding-left: 1rem;">
                    <xsl:choose>
                        <xsl:when test="tei:p">
                            <xsl:apply-templates/>
                        </xsl:when>
                        <xsl:otherwise>
                            <p><xsl:apply-templates/></p>
                        </xsl:otherwise>
                    </xsl:choose>                    
                </td>
            </tr>
        </table>
    </xsl:template>
    
    <xsl:template match="tei:table">
        <table class="table">
            <xsl:apply-templates/>
        </table>
    </xsl:template>
    
    <xsl:template match="tei:row">
        <tr>
            <xsl:apply-templates/>
        </tr>
    </xsl:template>
    
    <xsl:template match="tei:cell">
        <td>
            <xsl:apply-templates/>
        </td>
    </xsl:template>
    
    <xsl:template match="tei:persName">
        <span title="{@key}" style="background-color: #f0f0b8;">
            <xsl:attribute name="onclick">
                <xsl:text>explain('</xsl:text>
                <xsl:value-of select="string(.)"/>
                <xsl:text>','</xsl:text>
                <xsl:value-of select="@key"/>
                <xsl:text>');</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:placeName">
        <span title="{@key}" style="background-color: #fecac2;">
            <xsl:attribute name="onclick">
                <xsl:text>explain('</xsl:text>
                <xsl:value-of select="string(.)"/>
                <xsl:text>','</xsl:text>
                <xsl:value-of select="@key"/>
                <xsl:text>');</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:index">
        <span title="{@key}" style="background-color: #1b8be0;">
            <xsl:attribute name="onclick">
                <xsl:text>explain('</xsl:text>
                <xsl:value-of select="string(.)"/>
                <xsl:text>','</xsl:text>
                <xsl:value-of select="@key"/>
                <xsl:text>');</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:ref">
        <span title="link">
            <a href="{@target}">
                <xsl:apply-templates/>
            </a>
        </span>
    </xsl:template>
    
    <xsl:template name="adjustHiRend">
        <xsl:param name="rend"/>
        <xsl:if test="contains($rend,'underline')">
            <xsl:text>text-decoration: underline; </xsl:text>
        </xsl:if>
        <xsl:if test="contains($rend, 'italic')">
            <xsl:text>font-style: italic; </xsl:text>
        </xsl:if>
        <xsl:if test="contains($rend, 'bold')">
            <xsl:text>font-weight: bold; </xsl:text>
        </xsl:if>
        <xsl:if test="contains($rend, 'subscript')">
            <xsl:text>font-size: 80%; vertical-align: bottom; line-height: 100%; </xsl:text>
        </xsl:if>
        <xsl:if test="contains($rend, 'superscript')">
            <xsl:text>font-size: 70%; vertical-align: top; line-height: 100%; </xsl:text>
        </xsl:if>
        <xsl:if test="contains($rend, 'left')">
            <xsl:text>text-align: left; </xsl:text>
        </xsl:if>
        <xsl:if test="contains($rend, 'right')">
            <xsl:text>text-align: right; </xsl:text>
        </xsl:if>
        <xsl:if test="contains($rend, 'center')">
            <xsl:text>text-align: center; </xsl:text>
        </xsl:if>
        <xsl:if test="contains($rend, 'justify')">
            <xsl:text>text-align: justify; </xsl:text>
        </xsl:if>
        <xsl:if test="contains($rend, 'background(')">
            <xsl:analyze-string select="$rend" regex="background\((.*?)\)">
                <xsl:matching-substring>
                    <xsl:text>background-color: </xsl:text><xsl:value-of select="regex-group(1)"/><xsl:text>;</xsl:text>
                </xsl:matching-substring>
            </xsl:analyze-string>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="findPersNames">
        <xsl:for-each select="distinct-values(//tei:persName/@key)">
            <xsl:sort lang="de"/>
            <a title="Nameneintrag"><xsl:value-of select="."/></a>
            <xsl:if test="not(position()=last())"> | </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="findPlaceNames">
        <xsl:for-each select="distinct-values(//tei:placeName/@key)">
            <xsl:sort lang="de"/>
            <a title="Ortsnameneintrag"><xsl:value-of select="."/></a>
            <xsl:if test="not(position()=last())"> | </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="findIndexes">
        <xsl:for-each select="distinct-values(//tei:index/@key)">
            <xsl:sort lang="de"/>
            <a title="Indexeintrag"><xsl:value-of select="."/></a>
            <xsl:if test="not(position()=last())"> | </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="findTitle">
        <xsl:value-of select="//tei:titleStmt/tei:title"/>
    </xsl:template>
    
    <xsl:template name="findSender">
        <xsl:value-of select="//tei:titleStmt/tei:title/tei:persName[@role='sender']"/>
    </xsl:template>
    
    <xsl:template name="findRecipient">
        <xsl:value-of select="//tei:titleStmt/tei:title/tei:persName[@role='recipient']"/>
    </xsl:template>
    
    <xsl:template name="findDating">
        <xsl:value-of select="//tei:titleStmt/tei:title/tei:date"/>
    </xsl:template>
    
    <xsl:template name="findId">
        <xsl:value-of select="//tei:fileDesc/tei:sourceDesc//tei:idno"/>
    </xsl:template>
    
    <xsl:template name="findFilename">
        <xsl:param name="uri"/>
        <xsl:choose>
            <xsl:when test="contains($uri, '/')">
                <xsl:call-template name="findFilename">
                    <xsl:with-param name="uri" select="substring-after($uri, '/')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="contains($uri, '.')">
                        <xsl:value-of select="substring-before($uri, '.')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$uri"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>