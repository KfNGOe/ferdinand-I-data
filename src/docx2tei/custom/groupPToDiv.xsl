<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:uibk="http://igwee.uibk.ac.at/custom/ns"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs uibk tei"
    version="2.0">
    
    
    <xsl:output indent="no" method="xml"/>
    
    <xsl:param name="druckPattern">^Druck:.*$</xsl:param>
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="tei:body">
        <xsl:variable name="tablePos" as="xs:integer">
            <xsl:call-template name="findTablePos">
                <xsl:with-param name="parentNode" select="."/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="druckPos" as="xs:integer">
            <xsl:call-template name="findDruckPos">
                <xsl:with-param name="bodyNode" select="."/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="lastTranscriptPos" as="xs:integer">
            <xsl:call-template name="findLastTranscriptPos">
                <xsl:with-param name="parentNode" select="."/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="endPos" select="count(./node())" as="xs:integer"></xsl:variable>
        <!--<xsl:message>
            <xsl:text>tablePos: </xsl:text><xsl:value-of select="$tablePos"/>
            <xsl:text>
druckPos: </xsl:text><xsl:value-of select="$druckPos"/>
            <xsl:text>
lastTranscriptPos: </xsl:text><xsl:value-of select="$lastTranscriptPos"/>
            <xsl:text>
endPos: </xsl:text><xsl:value-of select="$endPos"/>
        </xsl:message>-->
        <xsl:choose>
            <xsl:when test="1 &lt;= $tablePos and $tablePos &lt; $druckPos and $druckPos &lt; $lastTranscriptPos and $lastTranscriptPos &lt; $endPos">
                <body>
                    <xsl:apply-templates select="@*"/>
                    <div type="header">
                        <xsl:call-template name="copyChildren">
                            <xsl:with-param name="parentNode" select="."/>
                            <xsl:with-param name="startPosition" select="1"/>
                            <xsl:with-param name="endPosition" select="$tablePos"/>
                        </xsl:call-template>
                    </div>
                    <div type="regesta">
                        <xsl:call-template name="copyChildren">
                            <xsl:with-param name="parentNode" select="."/>
                            <xsl:with-param name="startPosition" select="$tablePos+1"/>
                            <xsl:with-param name="endPosition" select="$druckPos"/>
                        </xsl:call-template>
                    </div>
                    <div type="transcript">
                        <xsl:call-template name="copyChildren">
                            <xsl:with-param name="parentNode" select="."/>
                            <xsl:with-param name="startPosition" select="$druckPos+1"/>
                            <xsl:with-param name="endPosition" select="$lastTranscriptPos"/>
                        </xsl:call-template>
                    </div>
                    <div type="notes">
                        <xsl:call-template name="copyChildren">
                            <xsl:with-param name="parentNode" select="."/>
                            <xsl:with-param name="startPosition" select="$lastTranscriptPos+1"/>
                            <xsl:with-param name="endPosition" select="$endPos"/>
                        </xsl:call-template>
                    </div>
                </body>
            </xsl:when>
            <xsl:otherwise>
                <body>
                    <xsl:apply-templates select="@*"/>
                    <div type="notRecognized">
                        <xsl:apply-templates/>
                    </div>
                </body>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="copyChildren">
        <xsl:param name="parentNode"/>
        <xsl:param name="startPosition"/>
        <xsl:param name="endPosition"/>
        <xsl:for-each select="$parentNode/node()">
            <xsl:if test="position() &gt;= $startPosition and position() &lt;= $endPosition">
                <xsl:apply-templates select="."/>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="findLastTranscriptPos">
        <xsl:param name="parentNode"/>
        <xsl:variable name="result">
            <uibk:results>
                <xsl:for-each select="$parentNode/node()">
                    <xsl:if test="name()='p' and normalize-space(string(.))!=''">
                        <xsl:variable name="isItalic">
                            <xsl:call-template name="paragraphInItalic">
                                <xsl:with-param name="pNode" select="."></xsl:with-param>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:if test="$isItalic='false'">
                            <uibk:result><xsl:value-of select="count(preceding-sibling::node())+1"/></uibk:result>
                        </xsl:if>
                    </xsl:if>
                </xsl:for-each>
            </uibk:results>
        </xsl:variable>
        <xsl:if test="$result//uibk:result">
            <xsl:value-of select="$result//uibk:result[position()=last()]"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="findTablePos">
        <xsl:param name="parentNode"/>
        <xsl:variable name="result">
            <uibk:results>
                <xsl:for-each select="$parentNode/node()">
                    <xsl:if test=".[name()='table']">
                        <uibk:result><xsl:value-of select="count(preceding-sibling::node())+1"/></uibk:result>
                    </xsl:if>
                </xsl:for-each>
            </uibk:results>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$result//uibk:result">
                <xsl:value-of select="$result//uibk:result[1]"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="-1"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="findDruckPos">
        <xsl:param name="bodyNode"/>
        <xsl:variable name="result">
            <uibk:results>
                <xsl:for-each select="$bodyNode/node()">
                    <xsl:if test=".[name()='p']">
                        <xsl:variable name="inItalic">
                            <xsl:call-template name="paragraphInItalic">
                                <xsl:with-param name="pNode" select="."/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:if test="$inItalic='true' and matches(.,$druckPattern)">
                            <uibk:result><xsl:value-of select="count(preceding-sibling::node())+1"/></uibk:result>
                        </xsl:if>
                    </xsl:if>
                </xsl:for-each>
            </uibk:results>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$result//uibk:result">
                <xsl:value-of select="$result//uibk:result[1]"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="-1"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="paragraphInItalic">
        <xsl:param name="pNode"/>
        <xsl:variable name="firstChild" select="$pNode/child::*[1]"></xsl:variable>
        <xsl:variable name="lastChild" select="$pNode/child::*[position()=last()]"/>
        <xsl:variable name="sepItalic">
            <xsl:call-template name="sepItalic">
                <xsl:with-param name="pNode" select="$pNode"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="textInItalic" select="string-join($sepItalic//uibk:italic,'')"/>        
        <xsl:variable name="textNotInItalic" select="string-join($sepItalic//uibk:notItalic, '')"/>
        <xsl:choose>
            <xsl:when test="not($firstChild[contains(@rend,'italic')]) and not($lastChild[contains(@rend,'italic')])">false</xsl:when>
            <xsl:when test="string-length($textInItalic) &gt; string-length($textNotInItalic)">true</xsl:when>
            <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
    <xsl:template name="sepItalic">
        <xsl:param name="pNode"/>
        <uibk:sepItalic>
            <xsl:for-each select="$pNode//text()[not(ancestor::tei:note)]">
                <xsl:variable name="inItalic">
                    <xsl:call-template name="textInItalic">
                        <xsl:with-param name="text" select="."/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="$inItalic='true'">
                        <uibk:italic><xsl:value-of select="."/></uibk:italic>
                    </xsl:when>
                    <xsl:otherwise>
                        <uibk:notItalic><xsl:value-of select="."/></uibk:notItalic>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </uibk:sepItalic>
    </xsl:template>
    
    <xsl:template name="textInItalic">
        <xsl:param name="text"/>
        <xsl:variable name="ancestorWithRend" select="$text/ancestor::*[@rend]"/>
        <xsl:variable name="rendStack">
            <xsl:for-each select="$ancestorWithRend">
                <xsl:value-of select="@rend"/>
                <xsl:text> | </xsl:text>
            </xsl:for-each>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$ancestorWithRend/*[position()=last()][@rend='normal']">false</xsl:when>
            <xsl:when test="contains($rendStack,'italic')">true</xsl:when>
            <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
        
    
    <xsl:template match="@*|*|text()|comment()">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    
    
</xsl:stylesheet>