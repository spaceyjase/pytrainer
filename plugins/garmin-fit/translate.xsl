<?xml version="1.0"?>

<!-- note defining a namespace for TrainingCenterDatabase as the translation does not seem to work with a default namespace -->
<xsl:stylesheet version="1.0"
xmlns:t="http://www.garmin.com/xmlschemas/TrainingCenterDatabase/v2"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>
<xsl:output  method="xml" indent="yes" omit-xml-declaration="no"/> 

<!-- this is a bit of a messy way to get whitespace into the output - but it works -->
<xsl:variable name="newline"><xsl:text>
</xsl:text></xsl:variable>

<xsl:template match="/">
    <gpx creator="pytrainer http://sourceforge.net/projects/pytrainer" version="1.1" 
	xmlns="http://www.topografix.com/GPX/1/1"
    xmlns:gpxdata="http://www.cluetrust.com/XML/GPXDATA/1/0" >

    <xsl:value-of select="$newline"/>
    <xsl:variable name="sport"><xsl:value-of select="t:Activity/@Sport"/></xsl:variable>
    <xsl:variable name="time"><xsl:value-of select="t:Activity/t:Id"/></xsl:variable>
    <xsl:variable name="name"><xsl:value-of select="$sport"/><xsl:value-of  select="substring($time, 1,10)"/></xsl:variable>
    <metadata><xsl:value-of select="$newline"/>
    <name><xsl:value-of select="$name"/></name><xsl:value-of select="$newline"/>
    <link href="http://sourceforge.net/projects/pytrainer"/><xsl:value-of select="$newline"/>
    <time><xsl:value-of select="$time"/></time><xsl:value-of select="$newline"/>
    </metadata><xsl:value-of select="$newline"/>
    <trk><xsl:value-of select="$newline"/>
    <xsl:for-each select="t:Activity/t:Lap">
        <trkseg><xsl:value-of select="$newline"/>
        <xsl:variable name="calories"><xsl:value-of select="t:Calories"/></xsl:variable>
        <xsl:for-each select="t:Track/t:Trackpoint">
            <!-- only output a trkpt if a position exists -->
            <xsl:if test="t:Position">
                <xsl:variable name="lat"><xsl:value-of select="t:Position/t:LatitudeDegrees"/></xsl:variable>
                <xsl:variable name="lon"><xsl:value-of select="t:Position/t:LongitudeDegrees"/></xsl:variable>
                <trkpt lat="{$lat}" lon="{$lon}"><xsl:value-of select="$newline"/>
                <ele><xsl:value-of select="t:AltitudeMeters"/></ele><xsl:value-of select="$newline"/>
                <time><xsl:value-of select="t:Time"/></time><xsl:value-of select="$newline"/>
				<xsl:if test="t:HeartRateBpm/t:Value">
	                <extensions><xsl:value-of select="$newline"/>
    	            <gpxdata:hr><xsl:value-of select="t:HeartRateBpm/t:Value"/></gpxdata:hr><xsl:value-of select="$newline"/>
    	            </extensions><xsl:value-of select="$newline"/>
				</xsl:if>
				<xsl:if test="t:Cadence">
	                <extensions><xsl:value-of select="$newline"/>
    	            <gpxdata:cadence><xsl:value-of select="t:Cadence"/></gpxdata:cadence><xsl:value-of select="$newline"/>
    	            </extensions><xsl:value-of select="$newline"/>
				</xsl:if>
                </trkpt><xsl:value-of select="$newline"/>
            </xsl:if>
        </xsl:for-each>
        <xsl:value-of select="$newline"/>        
        <extensions><xsl:value-of select="$newline"/>
        <gpxdata:sportType><xsl:value-of select="$sport"/></gpxdata:sportType><xsl:value-of select="$newline"/>
        <gpxdata:calories><xsl:value-of select="$calories"/></gpxdata:calories><xsl:value-of select="$newline"/>
        </extensions><xsl:value-of select="$newline"/>
        </trkseg><xsl:value-of select="$newline"/>
    </xsl:for-each>
    </trk><xsl:value-of select="$newline"/>
<!-- Lap Data -->
	<xsl:value-of select="$newline"/>
	<extensions><xsl:value-of select="$newline"/>
    <xsl:for-each select="t:Activity/t:Lap">
    <xsl:variable name="vIndex">
    <xsl:number count="t:Lap"/>
    </xsl:variable>
		<gpxdata:lap><xsl:value-of select="$newline"/>
			<gpxdata:index><xsl:value-of select="$vIndex"/></gpxdata:index><xsl:value-of select="$newline"/>
            <xsl:variable name="stlat"><xsl:value-of select="t:Track/t:Trackpoint[1]/t:Position/t:LatitudeDegrees"/></xsl:variable>
            <xsl:variable name="stlon"><xsl:value-of select="t:Track/t:Trackpoint[1]/t:Position/t:LongitudeDegrees"/></xsl:variable>
            <gpxdata:startPoint lat="{$stlat}" lon="{$stlon}"/><xsl:value-of select="$newline"/>
			<xsl:variable name="cnt"><xsl:value-of select="count(t:Track/t:Trackpoint/t:Position)-1"/></xsl:variable>
			<xsl:variable name="endlat"><xsl:value-of select="t:Track/t:Trackpoint[number($cnt)]/t:Position/t:LatitudeDegrees"/></xsl:variable>
   	  	  	<xsl:variable name="endlon"><xsl:value-of select="t:Track/t:Trackpoint[number($cnt)]/t:Position/t:LongitudeDegrees"/></xsl:variable>
      		<gpxdata:endPoint lat="{$endlat}" lon="{$endlon}"/><xsl:value-of select="$newline"/>
			<gpxdata:startTime><xsl:value-of select="@StartTime"/></gpxdata:startTime><xsl:value-of select="$newline"/>
			<gpxdata:elapsedTime><xsl:value-of select="t:TotalTimeSeconds"/></gpxdata:elapsedTime><xsl:value-of select="$newline"/>
			<gpxdata:calories><xsl:value-of select="t:Calories"/></gpxdata:calories><xsl:value-of select="$newline"/>
			<gpxdata:distance><xsl:value-of select="t:DistanceMeters"/></gpxdata:distance><xsl:value-of select="$newline"/>
			<!-- <gpxdata:trackReference>Reference information for the track which corresponds to this lap type="trackReferenceType"</gpxdata:trackReference><xsl:value-of select="$newline"/> -->
			<gpxdata:summary name="MaximumSpeed" kind="max"><xsl:value-of select="t:MaximumSpeed"/></gpxdata:summary><xsl:value-of select="$newline"/>
		    <gpxdata:summary name="AverageHeartRateBpm" kind="avg"><xsl:value-of select="t:AverageHeartRateBpm/t:Value"/></gpxdata:summary><xsl:value-of select="$newline"/>
			<gpxdata:summary name ="MaximumHeartRateBpm" kind="max"><xsl:value-of select="t:MaximumHeartRateBpm/t:Value"/></gpxdata:summary><xsl:value-of select="$newline"/>
            <xsl:variable name="trigger_kind"><xsl:value-of select="t:TriggerMethod"/></xsl:variable>
			<gpxdata:trigger kind="{$trigger_kind}" /><xsl:value-of select="$newline"/>
			<gpxdata:intensity><xsl:value-of select="t:Intensity"/></gpxdata:intensity><xsl:value-of select="$newline"/>
		</gpxdata:lap><xsl:value-of select="$newline"/>
    </xsl:for-each>
    </extensions><xsl:value-of select="$newline"/>

    </gpx><xsl:value-of select="$newline"/>
</xsl:template>
</xsl:stylesheet>
