<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ce="http://www.clicedit.org/schema_1.0" exclude-result-prefixes="ce" version="1.0">
    <!-- info see parent 'ph_main.xsl' -->

    <!-- <self:ph_movement.xsl> V.O. copy of ph_delivery.xsl 202002 -->

    <!-- #H2# preinclude see 'ph_main.xsl'/'# common inclusion' -->

    <!-- #H2# TEMPLATE -->

    <!-- Cmt: Header  -->
    <xsl:template match="ce:MovementRequestHeader">
        <div class="container border" ce="MovementRequestHeader">
            <xsl:if test="@sequenceNumbering">
                <div class="row border">
                    <div class="col-12">
                        <xsl:text>[</xsl:text>
                        <xsl:value-of select="@sequenceNumbering"/>
                        <xsl:text>]</xsl:text>
                    </div>
                </div>
            </xsl:if>

            <xsl:call-template name="buyerBillTo_mdRow"/>

            <xsl:call-template name="SupplierShipTo_mdRow"/>

        </div>

        <!--Cmt: [//] Contact Liste par catagories :   -->
        <div id="contactList" class="container border-top" ce="Contact List">
            <xsl:call-template name="tplContactList_multiCol"/>
        </div>

        <xsl:apply-templates mode="mdTableOpt" select="./ce:DocumentReference"/>

        <div class="container border" ce="AttachmentReference, DateInfo">
            <div class="row border">
                <div class="col-12">
                    <xsl:call-template name="nLoopExceptBr">
                        <!-- call: AttachmentReference, DateInfo -->
                        <xsl:with-param name="aExcept">!Buyer!ShipTo!Contact!Supplier!ShipTo!DocumentReference!Comment!IdReference!Extrinsic!</xsl:with-param>
                    </xsl:call-template>
                </div>
            </div>
        </div>

        <div class="container border" ce="Comment, IdReference, Extrinsic">
            <xsl:apply-templates mode="mdRow" select="ce:Comment"/>
            <xsl:call-template name="refIntExt_mdRow"/>
        </div>
    </xsl:template>



    <!-- Cmt_Block 'ce:MovementDetails' ctxt="ce:MovementRequest"
=================
Lgn,Col|col 1|col 2|col 3|col 4
Ligne 1, 4 colonnes|purpose, mouvementId, mouvementDate|operation|Quantity*|Item
ligne 2, 4 colonnes|ShipTo|ShipFrom|Extrinsic, IdReference, DocumentReference|Order
ligne 3, 2 colonnes|Reason|OrderDesc, Comment|
=================
    -->
    <xsl:template name="tplMvtDetails">
        <div class="container" ce="MovementDetails">
            <xsl:for-each select="ce:MovementDetails">
                <xsl:if test="1 = position()">
                    <div class="row border bg-secondary text-white align-items-center">
                        <div class="col-2 text-truncate" ce="ce:MovementDetails/@* != @operation">
                            <xsl:call-template name="getLabel">
                                <xsl:with-param name="aVal" select="'purpose'"/>
                            </xsl:call-template>
                        </div>
                        <div class="col-2 text-truncate" ce="ce:MovementDetails/@operation">
                            <xsl:call-template name="getLabel">
                                <xsl:with-param name="aList" select="local-name()"/>
                                <xsl:with-param name="aVal" select="'operation'"/>
                            </xsl:call-template>
                        </div>
                        <div class="col-3 text-truncate" ce="Quantity + InitialStock + FinalStock">
                            <xsl:call-template name="getLabel">
                                <xsl:with-param name="aVal" select="'Quantity'"/>
                            </xsl:call-template>
                        </div>
                        <div class="col-5" ce="ItemDetails">
                            <xsl:call-template name="getLabel">
                                <xsl:with-param name="aVal" select="'ItemDetails'"/>
                            </xsl:call-template>
                        </div>
                    </div>
                </xsl:if>
                <div class="row border-right border-bottom border-left ceBorderTop3" ce="ce:MovementDetails - row 1/3 - 4*cols">
                    <div class="col-2 text-truncate" ce="ce:MovementDetails/@* != @operation">
                        <xsl:choose>
                            <xsl:when test="@sequenceNumbering or @purpose or @movementId or @movementDate">
                                <xsl:if test="@sequenceNumbering">
                                    <div class="br">
                                        <xsl:value-of select="concat('[', @sequenceNumbering, ']')"/>
                                    </div>
                                </xsl:if>
                                <div class="br">
                                    <xsl:call-template name="getLabel">
                                        <xsl:with-param name="aVal" select="@purpose"/>
                                    </xsl:call-template>
                                </div>
                                <div class="br">
                                    <xsl:value-of select="@movementId"/>
                                </div>
                                <div class="br">
                                    <xsl:value-of select="@movementDate"/>
                                </div>
                                <xsl:if test="@sequenceNumbering">
                                    <div class="br">
                                        <xsl:value-of select="concat('[', @sequenceNumbering, ']')"/>
                                    </div>
                                </xsl:if>
                                <div class="br">
                                    <xsl:call-template name="getLabel">
                                        <xsl:with-param name="aVal" select="@purpose"/>
                                    </xsl:call-template>
                                </div>
                                <div class="br">
                                    <xsl:value-of select="@movementId"/>
                                </div>
                                <div class="br">
                                    <xsl:value-of select="@movementDate"/>
                                </div>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="tplEmptyCell"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </div>
                    <div class="col-2 text-truncate" ce="ce:MovementDetails/@operation">
                        <xsl:choose>
                            <xsl:when test="@operation">
                                <xsl:call-template name="getLabel">
                                    <xsl:with-param name="aList" select="'movement_operation_list_type'"/>
                                    <xsl:with-param name="aVal" select="@operation"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="tplEmptyCell"/>
                            </xsl:otherwise>
                        </xsl:choose>

                    </div>
                    <div class="col-3 text-truncate" ce="Quantity*">
                        <xsl:choose>
                            <xsl:when test="ce:Quantity or ce:IssueQuantity or ce:InitialStock or ce:FinalStock">
                                <xsl:apply-templates mode="md_n30" select="ce:Quantity | ce:IssueQuantity | ce:InitialStock | ce:FinalStock"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="tplEmptyCell"/>
                            </xsl:otherwise>
                        </xsl:choose>

                    </div>
                    <div class="col-5" ce="ItemDetails">
                        <xsl:choose>
                            <xsl:when test="ce:ItemDetails">
                                <xsl:apply-templates select="ce:ItemDetails"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="tplEmptyCell"/>
                            </xsl:otherwise>
                        </xsl:choose>

                    </div>
                </div>
                <div class="row border" ce="ce:MovementDetails - row 2/3 - 4*cols">
                    <div class="col-4" ce="ShipTo">
                        <xsl:choose>
                            <xsl:when test="ce:ShipTo">
                                <xsl:apply-templates select="ce:ShipTo"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="tplEmptyCell"/>
                            </xsl:otherwise>
                        </xsl:choose>

                    </div>
                    <div class="col-4" ce="ShipFrom">
                        <xsl:choose>
                            <xsl:when test="ce:ShipFrom">
                                <xsl:apply-templates select="ce:ShipFrom"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="tplEmptyCell"/>
                            </xsl:otherwise>
                        </xsl:choose>

                    </div>
                    <div class="col-4" ce="Extra(Extrinsic, IdReference, DocumentReference)">
                        <xsl:choose>
                            <xsl:when test=".//ce:Extrinsic or .//ce:IdReference or .//ce:DocumentReference">
                                <xsl:if test=".//ce:Extrinsic">
                                    <xsl:apply-templates mode="md_n30" select=".//ce:Extrinsic"/>
                                </xsl:if>
                                <xsl:if test=".//ce:IdReference">
                                    <xsl:apply-templates mode="md_n30" select=".//ce:IdReference"/>
                                </xsl:if>
                                <xsl:if test=".//ce:DocumentReference">
                                    <xsl:apply-templates mode="md_n30" select=".//ce:DocumentReference"/>
                                </xsl:if>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="tplEmptyCell"/>
                            </xsl:otherwise>
                        </xsl:choose>

                        <!-- missing elements : should not match-->
                        <xsl:call-template name="nLoopExceptBr">
                            <xsl:with-param name="aExcept">!Quantity!IssueQuantity!InitialStock!FinalStock!ItemDetails!ShipTo!ShipFrom!OrderDetails!Reason!Comment!Extrinsic!DocumentReference!</xsl:with-param>
                        </xsl:call-template>

                    </div>
                    <div class="col-4 text-truncate" ce="OrderDetails">
                        <xsl:choose>
                            <xsl:when test="ce:OrderDetails">
                                <xsl:apply-templates select="ce:OrderDetails"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="tplEmptyCell"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </div>
                </div>
                <div class="row border" ce="ce:MovementDetails - row 3/3 2*cols">
                    <div class="col-6" ce="Reason">
                        <xsl:choose>
                            <xsl:when test="ce:Reason">
                                <div class="br">
                                    <xsl:call-template name="getSpanLabel">
                                        <xsl:with-param name="aVal">Reason</xsl:with-param>
                                    </xsl:call-template>
                                </div>
                                <xsl:apply-templates select="ce:Reason"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="tplEmptyCell"/>
                            </xsl:otherwise>
                        </xsl:choose>

                    </div>
                    <div class="col-6" ce="Comment">
                        <xsl:choose>
                            <xsl:when test="./ce:OrderDetails/ce:OrderDesc or .//ce:Comment">
                                <xsl:if test="./ce:OrderDetails/ce:OrderDesc">
                                    <div class="br">
                                        <xsl:call-template name="getSpanLabel">
                                            <xsl:with-param name="aVal">OrderDesc</xsl:with-param>
                                        </xsl:call-template>
                                    </div>
                                    <xsl:apply-templates select="./ce:OrderDetails/ce:OrderDesc"/>
                                </xsl:if>
                                <xsl:if test=".//ce:Comment">
                                    <div class="br">
                                        <xsl:call-template name="getSpanLabel">
                                            <xsl:with-param name="aVal">Comment</xsl:with-param>
                                        </xsl:call-template>
                                    </div>
                                    <xsl:if test="ce:ItemDetails/ce:PaperItem/ce:Comment">
                                        <xsl:call-template name="getSpanLabel">
                                            <xsl:with-param name="aVal">PaperItem</xsl:with-param>
                                        </xsl:call-template>
                                        <xsl:apply-templates select="ce:ItemDetails/ce:PaperItem/ce:Comment"/>
                                    </xsl:if>
                                    <xsl:if test="ce:ItemDetails/ce:BookItem/ce:Comment">
                                        <xsl:call-template name="getSpanLabel">
                                            <xsl:with-param name="aVal">BookItem</xsl:with-param>
                                        </xsl:call-template>
                                        <xsl:apply-templates select="ce:ItemDetails/ce:BookItem/ce:Comment"/>
                                    </xsl:if>
                                    <xsl:if test="ce:ItemDetails/ce:Comment">
                                        <xsl:call-template name="getSpanLabel">
                                            <xsl:with-param name="aVal">ItemDetails</xsl:with-param>
                                        </xsl:call-template>
                                        <xsl:apply-templates select="ce:ItemDetails/ce:Comment"/>
                                    </xsl:if>
                                    <xsl:if test="ce:Comment">
                                        <xsl:apply-templates select="ce:Comment"/>
                                    </xsl:if>
                                </xsl:if>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="tplEmptyCell"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </div>
                </div>
            </xsl:for-each>
        </div>
    </xsl:template>

    <xsl:template match="ce:OrderDetails">
        <xsl:call-template name="nLoopExceptBr">
            <!-- call : OrderReference -->
            <xsl:with-param name="aExcept">!OrderDesc!IdReference!DocumentReference!Extrinsic!</xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="ce:ItemDetails">
        <!-- in a Cell (Div/Col-3)  -->
        <xsl:apply-templates select="ce:ItemDescriptionSupplier"/>
        <xsl:apply-templates select="ce:ItemDescriptionBuyer"/>
        <xsl:if test="ce:ItemDescription">
            <xsl:call-template name="n33">
                <!-- $aEltNodeList : input, list of tag with same elt -->
                <xsl:with-param name="aEltNodeLst" select="ce:ItemDescription"/>
                <xsl:with-param name="aSep" select="'!br'"/>
            </xsl:call-template>
        </xsl:if>
        <xsl:call-template name="nLoopExceptBr">
            <!-- call : PaperItem | BookItem -->
            <xsl:with-param name="aExcept">!ItemDescriptionSupplier!ItemDescriptionBuyer!ItemDescription!IdReference!DocumentReference!Comment!Extrinsic!</xsl:with-param>
        </xsl:call-template>
    </xsl:template>


    <xsl:template match="ce:PaperItem | ce:BookItem">
        <xsl:call-template name="nLoopExceptBr">
            <!-- call : ... -->
            <xsl:with-param name="aExcept">!IdReference!DocumentReference!Comment!</xsl:with-param>
        </xsl:call-template>
    </xsl:template>


    <!-- Cmt_Block 'MovementRequest' -->
    <xsl:template name="tplMovementRequest">
        <xsl:if test="starts-with($i_doc_type, 'dt_Movement')">
            <xsl:for-each select="./ce:Request/ce:MovementRequest">
                <!-- Cmt_Push: body -->

                <xsl:call-template name="nLoopExcept">
                    <!-- call : MovementRequestHeader  -->
                    <xsl:with-param name="aSep">!none</xsl:with-param>
                    <xsl:with-param name="aExcept">!MovementDetails!Comment!Extrinsic!</xsl:with-param>
                </xsl:call-template>


                <xsl:call-template name="tplMvtDetails"/>

                <!--Cmt row ce:Extrinsic + ce:Comment -->
                <div class="container border">
                    <xsl:call-template name="refIntExt_mdRow"/>
                    <xsl:apply-templates mode="mdRow" select="ce:Comment"/>
                </div>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
