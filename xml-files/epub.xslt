<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml" version="2.0">
    <!-- Global constants for building file names -->
    <xsl:variable name="FILE_PREFIX" select="'MacN'"/>
    <xsl:variable name="FILE_EXT" select="'.xhtml'"/>
    <xsl:variable name="CSS_FILE_NAME" select="'MacN1947.css'"/>
    <xsl:variable name="TRUNC_CHAPTER_NAME" select="3"/><!-- Number of characters to keep -->

    <xsl:strip-space elements="note"/>

    <xsl:output method="xhtml" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
        doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" 
		indent="yes"
        encoding="UTF-8"/>

    <xsl:template match="//teiHeader"/>

    <!-- Output title page as a separate file -->
    <xsl:template match="titlePage">
        <xsl:variable name="filename" select="concat($FILE_PREFIX, 'tit', $FILE_EXT)"/>
        <xsl:result-document href="{$filename}">
            <xsl:call-template name="section"/>
        </xsl:result-document>
    </xsl:template>

    <!-- Output each div1 as a separate file -->
    <xsl:template match="div1">
        <xsl:variable name="chapter_prefix" select="substring(@type, 1, $TRUNC_CHAPTER_NAME)"/>
        <xsl:variable name="filename" select="concat($FILE_PREFIX, $chapter_prefix, @n, $FILE_EXT)"/>
        <xsl:result-document href="{$filename}">
            <xsl:call-template name="section"/>
        </xsl:result-document>

    </xsl:template>

    <xsl:template name="section">
        <html>
            <head>
                <title>
                    <xsl:value-of select="//titleStmt/title[@type='main']"/> &#8212; <xsl:value-of
                        select="//titleStmt/title[@type='sub']"/>
                </title>
                <meta name="author" content="{//titleStmt/author}"/>
                <meta name="DC.Type" content="Text"/>
                <meta name="DC.Format" content="text/html"/>
                <meta name="LCSH" content="{string-join(//keywords[@scheme='LCSH']/term, ', ')}"/>
                <link type="text/css" href="{$CSS_FILE_NAME}" rel="stylesheet" media="all"/>
            </head>
            <body>
                <xsl:call-template name="page-wrapper"/>
            </body>
        </html>
    </xsl:template>

    <!-- page wrapper and navigation links -->
    <xsl:template name="page-wrapper">
        <xsl:choose>
            <xsl:when test="ancestor-or-self::div1">
                <div id="bookpage">
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <xsl:when test="ancestor-or-self::titlePage">
                <div id="titlepage">
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <p>Unknown ancestor element. Better revise your XSLT.</p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- headings for book main and sub titles -->
    <xsl:template match="titlePart">
        <xsl:choose>
            <xsl:when test="@type='main'">
                <!-- Main title -->
                <h1 id="main-title"><xsl:apply-templates/></h1>
            </xsl:when>
            <xsl:when test="@type='sub'">
                <!-- Sub title -->
                <h2 id="sub-title"><xsl:apply-templates/></h2>
			</xsl:when>
            <xsl:otherwise>
                <p>Unknown attribute type for titlePart element. Better revise your XSLT.</p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- author and publication information -->
    <xsl:template match="byline">
        <div id="byline">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="docAuthor">
        <div id="by">By</div>
        <div id="author">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="docEdition">
        <div id="edition">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="docImprint">
        <div id="imprint">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="docDate">
        <div id="date">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <!-- *** Templates for lower-level text mark-up *** -->
    <!-- headers, chapter and section -->
    <xsl:template match="title">
        <cite><xsl:apply-templates/></cite>
    </xsl:template>
    
    <xsl:template match="head">
        <xsl:choose>
            <xsl:when test="parent::div1">
                <h1>
                    <xsl:apply-templates/>
                    <xsl:if test="boolean(string-length(@id))">
                        <a id="{@id}">&#160;</a>
                    </xsl:if>
                </h1>
            </xsl:when>
            <xsl:when test="parent::div2">
                <h2>
                    <xsl:apply-templates/>
                    <xsl:if test="boolean(string-length(@id))">
                        <a id="{@id}">&#160;</a>
                    </xsl:if>
                </h2>
            </xsl:when>
            <xsl:otherwise>
                <p>Unknown parent of head element. Better revise your XSLT.</p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- highlighting -->
    <xsl:template match="hi">
        <xsl:choose>
            <xsl:when test="@rend='bold'">
                <strong>
                    <xsl:apply-templates/>
                </strong>
            </xsl:when>
            <xsl:when test="@rend='italic'">
                <em>
                    <xsl:apply-templates/>
                </em>
            </xsl:when>
            <xsl:when test="@rend='sup'">
                <span class="sup">
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
            <xsl:when test="@rend='sub'">
                <span class="sub">
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <p>Unknown value for attribute rend in hi element. Better revise your XSLT.</p>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <!-- line breaks -->
    <xsl:template match="lb">
        <br/>
    </xsl:template>

    <!-- links -->
    
    <xsl:template match="ref">
        <a href="#{@target}"><xsl:value-of select="."/></a>
    </xsl:template>

    <!-- lists -->
    <xsl:template match="list">
        <xsl:choose>
            <xsl:when test="@type='ordered'">
                <ol>
                    <xsl:apply-templates/>
                </ol>
            </xsl:when>
            <xsl:when test="@type='gloss'">
                <dl>
                    <xsl:apply-templates/>
                </dl>
            </xsl:when>
            <xsl:otherwise>
                <!-- bulleted or simple list -->
                <ul>
                    <xsl:apply-templates/>
                </ul>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="listBibl"><!-- Bibliography -->
        <ul class="biblio">
            <xsl:apply-templates/>
        </ul>
    </xsl:template>

    <xsl:template match="label[ancestor::list[@type='gloss']]">
        <!-- glossary -->
        <dt>
            <xsl:apply-templates/>
        </dt>
    </xsl:template>

    <xsl:template match="item">
        <xsl:choose>
            <xsl:when test="ancestor::list[@type='gloss']">
                <!-- glossary -->
                <dd>
                    <xsl:apply-templates/>
                </dd>
            </xsl:when>
            <xsl:otherwise>
                <!-- ordered, bulleted or simple list -->
                <li>
                    <xsl:apply-templates/>
                </li>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="bibl"><!-- bibliographic item -->
        <li><xsl:apply-templates/></li>
    </xsl:template>

    <!-- names -->
    <xsl:template match="author">
        <span class="author"><xsl:value-of select="."/></span>
    </xsl:template>
    
    <xsl:template match="name">
        <div class="name">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <!-- notes -->
    <xsl:template match="note[@target]">
        <!-- referent -->
        <a id="ref-{@target}" href="#{@target}" class="note-ref">
            <xsl:value-of select="."/>
        </a>
    </xsl:template>

    <xsl:template match="note[@id]">
        <!-- endnote -->
        <p>
            <a id="{@id}" href="#ref-{@id}">^</a>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <!-- page breaks -->
    <xsl:template match="pb" />

    <!-- paragraphs -->
    <xsl:template match="p">
        <xsl:choose>
            <xsl:when test="descendant::list">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <div class="bookpara">
                    <xsl:apply-templates/>
                </div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- quotation marks -->
    <xsl:template match="q">&#8220;<xsl:apply-templates/>&#8221;</xsl:template>

    <!-- tables -->
    <xsl:template match="table">
        <table>
            <xsl:apply-templates/>
        </table><br/>
    </xsl:template>
    
    <xsl:template match="row">
        <tr>
            <xsl:apply-templates/>
        </tr>
    </xsl:template>
    
    <xsl:template match="cell">
        <xsl:choose>
            <xsl:when test="@role='label'">
                <th>
                    <xsl:apply-templates/>
                </th>
            </xsl:when>
            <xsl:when test="@role='data'">
                <td>
                    <xsl:apply-templates/>
                </td>
            </xsl:when>
            <xsl:otherwise>
                <xsl:comment>Unknown role for cell element. Better revise your XSLT.</xsl:comment>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>
