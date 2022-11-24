<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:exsl="http://exslt.org/common" extension-element-prefixes="exsl" version="1.0">
  
  <xsl:import href="./custom/01.commentToRs.xsl"/>
  <xsl:import href="./custom/02.rsToRef.xsl"/>
  <xsl:import href="./custom/03.convertMetadata.xsl"/>
  <xsl:import href="./custom/03.insertSeparationAnchor.xsl"/>
  <xsl:import href="./custom/04.shiftSeparationAnchor.xsl"/>
  <xsl:import href="./custom/05.guessRegestPN.xsl"/>
  <xsl:import href="./custom/05.separationAnchorToDiv.xsl"/>
  <xsl:import href="./custom/06.addMissingRendKommentarInKommentar.xsl"/>
  <xsl:import href="./custom/06.deleteEmptyDiv.xsl"/>
  <xsl:import href="./custom/07.renameDivType.xsl"/>
  <xsl:import href="./custom/08.addNtoP.xsl"/>
  <xsl:import href="./custom/08.addNToPInDiv.xsl"/>
  <xsl:import href="./custom/09.removeN.xsl"/>
  <xsl:import href="./custom/10.addMetadata.xsl"/>
  <xsl:import href="./custom/11.replaceAbbrKeys.xsl"/>  
  
  <xsl:template match="/">
    <xsl:variable name="temp1">
      <xsl:apply-templates select="." mode="RHcommentToRs"/>
    </xsl:variable>
    <xsl:variable name="temp2">
      <xsl:apply-templates mode="RHrsToRef" select="exsl:node-set($temp1)"/>
    </xsl:variable>
    <xsl:variable name="temp3">
      <xsl:apply-templates mode="RHconvertMetadata" select="exsl:node-set($temp2)"/>
    </xsl:variable>
    <xsl:variable name="temp4">
      <xsl:apply-templates mode="RHinsertSeparationAnchor" select="exsl:node-set($temp3)"/>
    </xsl:variable>
    <xsl:variable name="temp5">
      <xsl:apply-templates mode="RHshiftSeparationAnchor" select="exsl:node-set($temp4)"/>
    </xsl:variable>
    <xsl:variable name="temp6">
      <xsl:apply-templates mode="RHguessRegestPN" select="exsl:node-set($temp5)"/>
    </xsl:variable>
    <xsl:variable name="temp7">
      <xsl:apply-templates mode="RHseparationAnchorToDiv" select="exsl:node-set($temp6)"/>
    </xsl:variable>
    <xsl:variable name="temp8">
      <xsl:apply-templates mode="RHaddMissingRendKommentarInKommentar" select="exsl:node-set($temp7)"/>
    </xsl:variable>
    <xsl:variable name="temp9">
      <xsl:apply-templates mode="RHdeleteEmptyDiv" select="exsl:node-set($temp8)"/>
    </xsl:variable>
    <xsl:variable name="temp10">
      <xsl:apply-templates mode="RHrenameDivType" select="exsl:node-set($temp9)"/>
    </xsl:variable>
    <xsl:variable name="temp11">
      <xsl:apply-templates mode="RHaddNtoP" select="exsl:node-set($temp10)"/>
    </xsl:variable>
    <xsl:variable name="temp12">
      <xsl:apply-templates mode="RHaddNToPInDiv" select="exsl:node-set($temp11)"/>
    </xsl:variable>
    <xsl:variable name="temp13">
      <xsl:apply-templates mode="RHremoveN" select="exsl:node-set($temp12)"/>
    </xsl:variable>         
    <xsl:variable name="temp14">
      <xsl:apply-templates mode="RHaddMetadata" select="exsl:node-set($temp13)"/>
    </xsl:variable>
    <xsl:apply-templates mode="RHreplaceAbbrKeys" select="exsl:node-set($temp14)"/>	
  </xsl:template>
</xsl:stylesheet>
