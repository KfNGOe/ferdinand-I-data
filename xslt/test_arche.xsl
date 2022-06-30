<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:acdh="https://vocabs.acdh.oeaw.ac.at/schema#"
    version="2.0" exclude-result-prefixes="#all">
    <xsl:output encoding="UTF-8" media-type="text" method="xml" version="1.0" indent="yes" omit-xml-declaration="yes"/>
    
    <xsl:template match="/">
        <xsl:variable name="constants">
            <xsl:for-each select=".//node()[parent::acdh:RepoObject]">
                <xsl:copy-of select="."/>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="TopColId">
            <xsl:value-of select="data(.//acdh:TopCollection/@rdf:about)"/>
        </xsl:variable>
        
        <rdf:RDF xmlns:acdh="https://vocabs.acdh.oeaw.ac.at/schema#">
            <acdh:TopCollection>
                <xsl:attribute name="rdf:about">
                    <xsl:value-of select=".//acdh:TopCollection/@rdf:about"/>
                </xsl:attribute>
                <xsl:copy-of select="$constants"/>
                <xsl:for-each select=".//node()[parent::acdh:TopCollection]">
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </acdh:TopCollection>
            
            <!-- 
            <xsl:for-each select=".//node()[parent::acdh:MetaAgents]">
                <xsl:copy-of select="."/>
            </xsl:for-each>
            -->
            
            <xsl:for-each select=".//acdh:Collection">
                <acdh:Collection>
                    <xsl:attribute name="rdf:about"><xsl:value-of select="@rdf:about"/></xsl:attribute>
                    <xsl:copy-of select="$constants"/>
                    <xsl:for-each select=".//node() [parent::acdh:Collection]">
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                </acdh:Collection>
            </xsl:for-each>
            
            <xsl:variable name="partOf_edit">
                <!-- <xsl:value-of select="@xml:base"/> -->
                <xsl:value-of select=".//acdh:Collection[1]/@rdf:about"/>                    
            </xsl:variable>            
            <xsl:variable name="coll_edit" select="doc('../data/dtabf_id/band_001/collection.xml')"/>        
            <xsl:for-each select="$coll_edit//doc/@href">
                <xsl:variable name="edit_path">
                    <xsl:value-of select="."/>
                </xsl:variable>
                <xsl:variable name="edit" select="doc($edit_path)//tei:TEI"/>
                
                <!-- RH: xxxx? ID's from ARCHE -->
                <!-- 
                <xsl:variable name="partOf">
                    <xsl:value-of select="@xml:base"/>                                        
                </xsl:variable>
                -->
                <xsl:variable name="id">
                    <xsl:value-of select="concat($partOf_edit, '/nnnn')"/>
                </xsl:variable>
                <xsl:variable name="flatId">
                    <xsl:value-of select="concat($TopColId, '/', @xml:id)"/>
                </xsl:variable>
                
                <acdh:Resource rdf:about="{$id}">
                    <acdh:hasIdentifier rdf:resource="{$flatId}"/>
                    <!--<acdh:hasPid><xsl:value-of select=".//tei:idno[@type='handle']/text()"/></acdh:hasPid>-->
                    <acdh:hasTitle xml:lang="de">
                        <xsl:value-of select="concat($edit//tei:title[@type='main'][1]/text(),' ', $edit//tei:title[@type='sub'][1]/text())"/>
                    </acdh:hasTitle>
                    <!--<acdh:hasCoverage xml:lang="de"><xsl:value-of select="$datum"/></acdh:hasCoverage>-->
                    <acdh:hasAccessRestriction rdf:resource="https://vocabs.acdh.oeaw.ac.at/archeaccessrestrictions/public"/>
                    <acdh:hasCategory rdf:resource="https://vocabs.acdh.oeaw.ac.at/archecategory/text/tei"/>
                    <acdh:hasLanguage rdf:resource="https://vocabs.acdh.oeaw.ac.at/iso6393/deu"/>
                    <acdh:isPartOf rdf:resource="{$partOf_edit}"/>
                    <!--                    <acdh:hasCoverageStartDate rdf:datatype="http://www.w3.org/2001/XMLSchema#date"><xsl:value-of select="$datum"/></acdh:hasCoverageStartDate>-->
                    <xsl:copy-of select="$constants"/>
                    
                    <xsl:for-each select=".//tei:place[@xml:id]">
                        <xsl:variable name="entId">
                            <xsl:choose>
                                <xsl:when test=".//tei:idno[@type='geonames']">
                                    <xsl:value-of select=".//tei:idno[@type='geonames']/text()"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="concat('https://id.acdh.oeaw.ac.at/pmb/', (substring-after(@xml:id, 'pmb')))"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <acdh:hasSpatialCoverage><!-- RH: ?xxxx -->
                            <acdh:Place>
                                <xsl:attribute name="rdf:about"><xsl:value-of select="$entId"/></xsl:attribute>
                                <acdh:hasTitle xml:lang="und"><xsl:value-of select=".//tei:placeName[1]/text()"/></acdh:hasTitle>
                            </acdh:Place>
                        </acdh:hasSpatialCoverage>
                    </xsl:for-each>
                    <xsl:for-each select=".//tei:person[@xml:id]">
                        <xsl:variable name="entId">
                            <xsl:choose>
                                <xsl:when test=".//tei:idno[@type='gnd']">
                                    <xsl:value-of select=".//tei:idno[@type='gnd']/text()"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="concat('https://id.acdh.oeaw.ac.at/pmb/', (substring-after(@xml:id, 'pmb')))"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <acdh:hasActor><!-- RH: ?xxxx -->
                            <acdh:Person>
                                <xsl:attribute name="rdf:about"><xsl:value-of select="$entId"/></xsl:attribute>
                                <acdh:hasTitle xml:lang="und"><xsl:value-of select=".//tei:forename[1]/text()||' '||.//tei:surname[1]/text()"/></acdh:hasTitle>
                            </acdh:Person>
                        </acdh:hasActor>
                    </xsl:for-each>
                    <xsl:for-each select=".//tei:org[@xml:id]">
                        <xsl:variable name="entId">
                            <xsl:value-of select="concat('https://id.acdh.oeaw.ac.at/pmb/', @xml:id)"/>
                        </xsl:variable>
                        <acdh:hasActor>
                            <acdh:Organisation><!-- RH: ?xxxx -->
                                <xsl:attribute name="rdf:about"><xsl:value-of select="$entId"/></xsl:attribute>
                                <acdh:hasTitle xml:lang="und"><xsl:value-of select=".//tei:orgName[1]/text()"/></acdh:hasTitle>
                            </acdh:Organisation>
                        </acdh:hasActor>
                    </xsl:for-each>
                    
                </acdh:Resource>
            </xsl:for-each>
            
            <xsl:variable name="partOf_reg">
                <!-- <xsl:value-of select="@xml:base"/> -->
                <xsl:value-of select=".//acdh:Collection[2]/@rdf:about"/>                    
            </xsl:variable>
            <xsl:variable name="coll_reg" select="doc('../data/register/collection.xml')"/>        
            <xsl:for-each select="$coll_reg//doc/@href">
                <xsl:variable name="reg_path">
                    <xsl:value-of select="."/>
                </xsl:variable>
                <xsl:variable name="reg" select="doc($reg_path)//tei:TEI"/>
                
                <!-- RH: ID's from ARCHE xxxx? -->
                <!-- 
                <xsl:variable name="partOf">
                    <xsl:value-of select="@xml:base"/>                                        
                </xsl:variable>
                -->
                <xsl:variable name="id">
                    <xsl:value-of select="concat($partOf_reg, '/nnnn')"/>
                </xsl:variable>
                <xsl:variable name="flatId">
                    <xsl:value-of select="concat($TopColId, '/', @xml:id)"/>
                </xsl:variable>
                
                <acdh:Resource rdf:about="{$id}">
                    <acdh:hasIdentifier rdf:resource="{$flatId}"/>
                    <!--<acdh:hasPid><xsl:value-of select=".//tei:idno[@type='handle']/text()"/></acdh:hasPid>-->
                    <acdh:hasTitle xml:lang="de">
                        <xsl:value-of select="$reg//tei:title"/>
                    </acdh:hasTitle>
                    <!--<acdh:hasCoverage xml:lang="de"><xsl:value-of select="$datum"/></acdh:hasCoverage>-->
                    <acdh:hasAccessRestriction rdf:resource="https://vocabs.acdh.oeaw.ac.at/archeaccessrestrictions/public"/>
                    <acdh:hasCategory rdf:resource="https://vocabs.acdh.oeaw.ac.at/archecategory/text/tei"/>
                    <acdh:hasLanguage rdf:resource="https://vocabs.acdh.oeaw.ac.at/iso6393/deu"/>
                    <acdh:isPartOf rdf:resource="{$partOf_reg}"/>
                    <!--                    <acdh:hasCoverageStartDate rdf:datatype="http://www.w3.org/2001/XMLSchema#date"><xsl:value-of select="$datum"/></acdh:hasCoverageStartDate>-->
                    <xsl:copy-of select="$constants"/>
                    
                    <xsl:for-each select=".//tei:place[@xml:id]">
                        <xsl:variable name="entId">
                            <xsl:choose>
                                <xsl:when test=".//tei:idno[@type='geonames']">
                                    <xsl:value-of select=".//tei:idno[@type='geonames']/text()"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="concat('https://id.acdh.oeaw.ac.at/pmb/', (substring-after(@xml:id, 'pmb')))"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <acdh:hasSpatialCoverage><!-- RH: ?xxxx -->
                            <acdh:Place>
                                <xsl:attribute name="rdf:about"><xsl:value-of select="$entId"/></xsl:attribute>
                                <acdh:hasTitle xml:lang="und"><xsl:value-of select=".//tei:placeName[1]/text()"/></acdh:hasTitle>
                            </acdh:Place>
                        </acdh:hasSpatialCoverage>
                    </xsl:for-each>
                    <xsl:for-each select=".//tei:person[@xml:id]">
                        <xsl:variable name="entId">
                            <xsl:choose>
                                <xsl:when test=".//tei:idno[@type='gnd']">
                                    <xsl:value-of select=".//tei:idno[@type='gnd']/text()"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="concat('https://id.acdh.oeaw.ac.at/pmb/', (substring-after(@xml:id, 'pmb')))"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <acdh:hasActor><!-- RH: ?xxxx -->
                            <acdh:Person>
                                <xsl:attribute name="rdf:about"><xsl:value-of select="$entId"/></xsl:attribute>
                                <acdh:hasTitle xml:lang="und"><xsl:value-of select=".//tei:forename[1]/text()||' '||.//tei:surname[1]/text()"/></acdh:hasTitle>
                            </acdh:Person>
                        </acdh:hasActor>
                    </xsl:for-each>
                    <xsl:for-each select=".//tei:org[@xml:id]">
                        <xsl:variable name="entId">
                            <xsl:value-of select="concat('https://id.acdh.oeaw.ac.at/pmb/', @xml:id)"/>
                        </xsl:variable>
                        <acdh:hasActor>
                            <acdh:Organisation><!-- RH: ?xxxx -->
                                <xsl:attribute name="rdf:about"><xsl:value-of select="$entId"/></xsl:attribute>
                                <acdh:hasTitle xml:lang="und"><xsl:value-of select=".//tei:orgName[1]/text()"/></acdh:hasTitle>
                            </acdh:Organisation>
                        </acdh:hasActor>
                    </xsl:for-each>
                    
                </acdh:Resource>
            </xsl:for-each>
            
        </rdf:RDF>        
        
    </xsl:template>   
</xsl:stylesheet>