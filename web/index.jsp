<%--
Document   : login
Author     : Divya Reddy Anugu
--%>
<%@ page contentType="text/html" %>
<%@ page pageEncoding="UTF-8" %>
<%@ page session="true" %>
<%
            String domain = (String) session.getAttribute("domain");

            if (domain == null) {
                domain = request.getRequestURL().toString();
                int end = domain.indexOf(request.getServletPath());
                domain = domain.substring(0, end == -1 ? domain.length() - 1 : end);
                session.setAttribute("domain", domain);
            }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="content-type" content="text/html; charset=utf-8"><title>SFSU / City Of Oakland Solar Energy Project</title>
            <link href="<%=domain%>/css/default.css" rel="stylesheet" type="text/css" />
            <!--
             <script type="text/javascript" src="https://www.google.com/jsapi?key=ABQIAAAALwb25IR2fJddvXhxh-B0VhT2yXp_ZAY8_ufC3CFXhHIE1NvwkxSg64kZN_mb_Ed79poahKsISZ1mkw"> </script>
            -->

            <script type="text/javascript" src="https://www.google.com/jsapi?key=ABQIAAAALwb25IR2fJddvXhxh-B0VhS4tN3Xp5_DBMdF7xUAP7eDAIPoARTuHEexs2X2QeneMvd0li8GSaGViA">
            </script>
            <script src="extensions.js" type="text/javascript"></script>
            <script type="text/javascript">
                var ge = null;
                var isMouseDown = false;
                var lineStringPlacemark = null;
                var coords = null;
                var pointCount = 0;
                var doc = null;
                var planeCount = 0;
                var obCount = 0;
                var planeArray = new Array();
                var isPlaneActive = false;
                var isObsActive = false;

                var AreaList = new Array();
                var PlaneList = new Array();
                var ObsList = new Array();

                function Area ()  {
                    this.id = 0;
                    this.areaType = "";
                    this.polygon = new geo.Polygon();
                    this.area = 0;
                    this.effectiveArea = 0;
                    this.refPlaneId = -1;
                }
                function addSampleButton(caption, clickHandler) {
                    var btn = document.createElement('input');
                    btn.type = 'button';
                    btn.value = caption;

                    if (btn.attachEvent)
                        btn.attachEvent('onclick', clickHandler);
                    else
                        btn.addEventListener('click', clickHandler, false);

                    // add the button to the Sample UI
                    document.getElementById('sample-ui').appendChild(btn);
                }

                function addSampleUIHtml(html) {
                    document.getElementById('sample-ui').innerHTML += html;
                }
                
                function clearAreaUIHtml() {
                    document.getElementById('area-ui').innerHTML = "";
                    

                }

                function roundNumber(num, dec) {
                    var result = Math.round(num*Math.pow(10,dec))/Math.pow(10,dec);
                    return result;
                }

            </script>

            <script type="text/javascript">
                var ge = null;
                var gex = null;
                var myLatlng;
                google.load("earth", "1");
                google.load("maps", "2");

    
                function initCallback(pluginInstance) {
                    ge = pluginInstance;
                    ge.getWindow().setVisibility(true);

                    gex = new GEarthExtensions(pluginInstance);



                    // add a navigation control
                    ge.getNavigationControl().setVisibility(ge.VISIBILITY_AUTO);

                    // add some layers
                    ge.getLayerRoot().enableLayerById(ge.LAYER_BORDERS, true);
                    ge.getLayerRoot().enableLayerById(ge.LAYER_ROADS, true);
                    ge.getOptions().setScaleLegendVisibility(true);
                    //document.getElementById('installed-plugin-version').innerHTML =
                    //ge.getPluginVersion().toString();
                    doc = ge.createDocument('');
                    ge.getFeatures().appendChild(doc);

                }

                function failureCallback(errorCode) {
                }

                function buttonClick() {
                    var geocodeLocation = document.getElementById('location').value;
                    var geocoder = new google.maps.ClientGeocoder();
                    geocoder.getLatLng(geocodeLocation, function(point) {
                        if (point) {
                            // var lookAt = ge.createLookAt('');

                            //gex.util.lookAt(point.y, point.x, 10, ge.ALTITUDE_RELATIVE_TO_GROUND, 0, 0, 30);
                            gex.util.lookAt([point.y, point.x], { range: 50 });
                            //lookAt.set();
                            //ge.getView().setAbstractView(lookAt);
                        }
                    });

                }

                google.setOnLoadCallback(function() {
                    google.earth.createInstance('map3d', initCallback, failureCallback);

                    addSampleUIHtml(
                    '<input id="location" type="text" style="width:160px;" value="835 Milton St, Oakland, CA"/>'
                );

                    addSampleButton('Load Property', buttonClick);

                    document.getElementById('undo-plane').disabled = true;
                    document.getElementById('undo-obs').disabled = true;
                    document.getElementById('save-plane').disabled = true;
                    document.getElementById('save-obs').disabled = true;


                });

                var polyPlacemark = null;

                function drawPoly(areaType) {
                    var drawColor = '#0f0';
                    var polyColor = '8000ff00';
                    if(areaType == "plane") {
                        isPlaneActive = true;
                        document.getElementById("undo-plane").disabled = false;
                        document.getElementById("save-plane").disabled = false;
                        drawColor = '#0f0';
      
                    }
                    else if (areaType == "obstruction") {
                        isObsActive = true;
                        document.getElementById("undo-obs").disabled = false;
                        document.getElementById("save-obs").disabled = false;
                        drawColor = '#f00';
                        polyColor = '800000ff';
                    }
                    polyPlacemark = gex.dom.addPolygonPlacemark([], {
                        style: {
                            poly: polyColor,
                            line: { width: 3, color: drawColor }
                        }
                    });
                    gex.edit.drawLineString(polyPlacemark.getGeometry().getOuterBoundary());

                }

                function undoLastPoint() {

                    gex.dom.removeObject(polyPlacemark);
                    gex.edit.endEditLineString(polyPlacemark.getGeometry().getOuterBoundary());
                    polyPlacemark = null;
                }

                function editPoly() {
                    if (!polyPlacemark) {
                        alert('You must draw a poly before editing it!');
                        return;
                    }

                    gex.edit.editLineString(polyPlacemark.getGeometry().getOuterBoundary());
                }

                function stopEditPoly(areaType) {
                    if (!polyPlacemark) {
                        alert('No poly to stop editing!');

                        return;
                    }

                    gex.edit.endEditLineString(polyPlacemark.getGeometry().getOuterBoundary());
  
                    updateAreaList(polyPlacemark, areaType);
                    //Disable undo button
                    if(areaType == "plane") {
                        isPlaneActive = false;
                        document.getElementById("undo-plane").disabled = true;
                        document.getElementById("save-plane").disabled = true;
                    } else if(areaType == "obstruction") {
                        isObsActive = false;
                        document.getElementById("undo-obs").disabled = true;
                        document.getElementById("save-obs").disabled = true;

                    }

                }

                // create the distance updater function
                function updateAreaList(polyPlacemark, areaType) {
                    var newArea = new Area();
                    
                    var newPolygon = new geo.Polygon(polyPlacemark.getGeometry().getOuterBoundary());

                    //Calculate Area of the polygon
                    var areaSqMt = newPolygon.area();
                    //convert area in Square Meters to Square Feet
                    var areaSqFt = roundNumber(10.7639104 * areaSqMt, 2);
                    
                    //Construct Area object
                    newArea.area = areaSqFt;
                    // newArea.id = ++planeCount;
                    newArea.areaType = areaType;
                    newArea.effectiveArea = areaSqFt;
                    newArea.polygon = newPolygon;

                    //Update UI
                    if(areaType == "plane") {
                        planeCount = planeCount + 1;
                        newArea.id = planeCount;

                        /*  addPlaneUIHtml(
                            '<strong>Plane '+ planeCount+': </strong><span id="distance' +planeCount +'">'+ roundNumber(areaSqFt,2) +' SqFt</span> <br/>'
                        );*/
AreaList.push(newArea);

                    }
                    if (areaType == "obstruction") {
                        //obCount = obCount + 1;
                        //var validObs = false;
                        PlaneList = [];
                        ObsList = [];
                        newArea.refPlaneId = getParentPlaneId(newArea);
                        if(newArea.refPlaneId != -1) {
                            AreaList.push(newArea);
                            updateEffectivePlaneArea(newArea.refPlaneId, newArea.area);
                        } else {
                            alert("Obstruction must lie entirely in one plane");
                            undoLastPoint();
                        }

                    }

                    
                    refreshAreaListUI();
                }

                function updateEffectivePlaneArea(id, area) {
                    for(var i in AreaList) {
                        if(AreaList[i].id == id) {
                            AreaList[i].effectiveArea -=roundNumber(area,2);
                        }
                    }
                }

                function refreshAreaListUI() {
                    clearAreaUIHtml();
                    var totalArea = 0;
                    //ObsList = [];
                    PlaneList = getPlanes();
                    ObsList = getObstructions();
                    for(var a in PlaneList) {
                        document.getElementById('area-ui').innerHTML += "<br/> Plane " + PlaneList[a].id + ": " + roundNumber(PlaneList[a].effectiveArea,2) + " Sq Ft <br/>";
                        totalArea += PlaneList[a].effectiveArea;
                        // Check obstructions related to the plane
                        for(var b in ObsList) {
                            if(ObsList[b].refPlaneId == PlaneList[a].id) {
                                document.getElementById('area-ui').innerHTML += "&nbsp;&nbsp;&nbsp;&nbsp;Obstruction : " + roundNumber(ObsList[b].area,2) + " Sq Ft <br/>";

                            }
                        }
                    }
            document.getElementById('area-ui').innerHTML += "<br/><br/> <b> Total Available Area : </b>" + roundNumber(totalArea,2) +" Sq Ft <br/>";


                }

                function getPlanes() {
                    PlaneList = new Array();
                    for(var i in AreaList) {
                        if(AreaList[i].areaType == "plane") {
                            PlaneList.push(AreaList[i]);
                        }
                    }
                    return PlaneList;
                }

                function getObstructions() {
                    ObsList = new Array();
                    for(var i in AreaList) {
                        if(AreaList[i].areaType == "obstruction") {
                            ObsList.push(AreaList[i]);
                        }
                    }
                    return ObsList;

                }

                function getParentPlaneId(newArea) {
                    //Check if obstruction is valid, i.e, to which plane it belongs to
                    var numC = newArea.polygon.outerBoundary().numCoords();
                        
                    var planes = getPlanes();
                    for(var a in planes) {
                        var x = 0;
                        for (var i = 0; i < numC; i++) {

                            // for(var p in newArea.polygon.outerBoundary().) {

                            if (planes[a].polygon.containsPoint(newArea.polygon.outerBoundary().coord(i)))
                            {
                                x++;
                            }
                            if(x == numC) {
                                //newArea.refPlaneId = AreaList[a].id;
                                return planes[a].id;
                            }
                        }

                    }
                    return -1;

                }

                function clearAllAreas() {

                    gex.dom.clearFeatures();
                    clearAreaUIHtml();
                    AreaList = new Array();
                    planeCount = 0;
                    //clearObsUIHtml();
        
                }
            </script>


    </head>
    <body>

        <div id="header">
            <div id="logo">
                <h1><a href="">Solar Opportunity</a></h1>
            </div>
        </div>

        <div>
            <table width="100%">
                <tr>
                    <td style="width:20%;" valign="top">
                        <div id="sample-ui" nowrap="nowrap"></div>
                        <br/>
                        <div>
                            <label><b>PLANES & OBSTRUCTIONS</b></label>
                            <input type="button" onclick="clearAllAreas();" value="Clear All"/>
                        </div>
                        
                        <div >
                            <div id="area-ui" style="height:300px;border-color:gray;border-style:ridge; "></div>
                         
                            <table width="100%">
                                <tr>                                    
                                    <td>
                                        
                            <input type="button" onclick="drawPoly('plane');" value="Add Plane"/>
            
                                    </td>
                                    <td align="right">
                            <input id="undo-plane" type="button" onclick="undoLastPoint();" value="Undo"/>
                            <input id="save-plane" type="button" onclick="stopEditPoly('plane');" value="Finish"/>
                           
                                    </td>
                                    
                                </tr>
                                <tr>
                                    
                                    <td>
                            <input type="button" onclick="drawPoly('obstruction');" value="Add Obstruction"/>
                                        
                                    </td>
                                    <td align="right">
                           <input id="undo-obs" type="button" onclick="undoLastPoint();" value="Undo"/>
                            
                                        <input id="save-obs" type="button" onclick="stopEditPoly('obstruction');" value="Finish"/>
                                        
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                            
                          
                                    </td>
                                </tr>
                            </table>                            
                            
                            <br/>
                            <p id="kml"> </p>
                        </div>

                    </td>

                    <td style="width:80%;">
                        <div id="map3d_container" style="width: 100%; height: 800px;">
                            <div id="map3d" style="height: 100%"></div>
                        </div>
                    </td>
                </tr>
            </table>



            <!-- end content -->

        </div>

        <div id="footer">
            <table width="100%">
                <tbody><tr>
                        <td align="left">
                            <p>©2008 San Francisco State University.</p>
                        </td>
                        <td align="center">
                            <p><a href="<%=domain%>/secure/about.jsp">About</a> | <a href="<%=domain%>/secure/credits.jsp">Credits</a> </p>
                        </td>
                        <td align="right">
                            <p><i>(Based on a design by <a href="http://www.freecsstemplates.org/">Free CSS Templates</a>)</i></p>
                        </td>
                    </tr>
                </tbody></table>
        </div>
    </body>
</html>
