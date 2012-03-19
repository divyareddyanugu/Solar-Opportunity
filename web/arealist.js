/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */


function drawPoly(areaType) {
                    var drawColor = '#0f0';
                    var polyColor = '8000ff00';
                    if(areaType == "plane") {
                        isPlaneActive = true;
                        document.getElementById("undo-plane").disabled = false;
                        document.getElementById("undoplane-point").disabled = false;
                        document.getElementById("save-plane").disabled = false;
                        drawColor = '#0f0';
                    }
                    else if (areaType == "obstruction") {
                        isObsActive = true;
                        document.getElementById("undo-obs").disabled = false;
                        document.getElementById("undoobs-point").disabled = false;
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
                   // var options;
                    //options.ensureCounterClockwise = false;
                    gex.edit.drawLineString(polyPlacemark.getGeometry().getOuterBoundary());

                }

                function undoLastArea() {
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
                    else if(polyPlacemark.getGeometry().getOuterBoundary().getCoordinates().getLength() < 3) {
                        alert('Polygon should have atleast 3 points');
                        return;
                    }
                    else {
                    gex.edit.endEditLineString(polyPlacemark.getGeometry().getOuterBoundary());

                    updateAreaList(polyPlacemark, areaType);
                    //Disable undo button
                    if(areaType == "plane") {
                        isPlaneActive = false;
                        document.getElementById("undo-plane").disabled = true;
                        document.getElementById("undoplane-point").disabled = true;
                        document.getElementById("save-plane").disabled = true;
                    } else if(areaType == "obstruction") {
                        isObsActive = false;
                        document.getElementById("undo-obs").disabled = true;
                        document.getElementById("undoobs-point").disabled = true;
                        document.getElementById("save-obs").disabled = true;
                    }
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
                    newArea.areaType = areaType;
                    newArea.effectiveArea = areaSqFt;
                    newArea.polygon = newPolygon;

                    //Update UI
                    if(areaType == "plane") {
                        planeCount = planeCount + 1;
                        newArea.id = planeCount;
                        AreaList.push(newArea);
                    }

                    if (areaType == "obstruction") {
                        PlaneList = [];
                        ObsList = [];
                        newArea.refPlaneId = getParentPlaneId(newArea);
                        if(newArea.refPlaneId != -1) {
                            AreaList.push(newArea);
                            updateEffectivePlaneArea(newArea.refPlaneId, newArea.area);
                        } else {
                            alert("Obstruction must lie entirely in one plane");
                            undoLastArea();
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
                    PlaneList = getPlanes();
                    ObsList = getObstructions();
                    for(var a in PlaneList) {
                        document.getElementById('area-ui').innerHTML += "<b>Plane " + PlaneList[a].id + ": </b> " + roundNumber(PlaneList[a].effectiveArea,2) + " Sq Ft <br/>";
                        document.getElementById('area-ui').innerHTML += "&nbsp;Orientation: <input id='orientation" +PlaneList[a].id+ "' type='text' "+
                            "onchange=\"validateOrientation("+PlaneList[a].id +",this.value );\" maxlength='3' "+
                            "title='Angle of the roof in degrees. Value lies between 0 & 360 degrees.' " +
                            " style=\"width:20px;\"/> degrees <br/>" +
                            "&nbsp;Slope: <input id='rise" +PlaneList[a].id+ "' " +
                            "onchange=\"validateRise("+PlaneList[a].id +",this.value );\" maxlength='2' "+
                            "title='Roof pitch is a numerical measure of the steepness of a roof. See Help for more info.' " +
                            " type=text style='width:20px;margin-left:2.7em;'/> ft / "+
                            "<input id='run" +PlaneList[a].id+ "' "+
                            "onchange=\"validateRun("+PlaneList[a].id +",this.value );\" maxlength='2' "+
                            "title='Roof pitch is a numerical measure of the steepness of a roof. See Help for more info.' " +
                            " type=text style='width:20px;'/> ft  (rise/run) ";

                        totalArea += PlaneList[a].effectiveArea;
                        // Check obstructions related to the plane
                        for(var b in ObsList) {
                            if(ObsList[b].refPlaneId == PlaneList[a].id) {
                                document.getElementById('area-ui').innerHTML += "<br/>&nbsp;&nbsp;&nbsp;&nbsp;<b>Obstruction : </b>" + roundNumber(ObsList[b].area,2) + " Sq Ft  ";
                                }
                        }
                        document.getElementById('area-ui').innerHTML += "<p style=\"border-bottom: 1px dotted #000000; width: 260px;\">";
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
                            if (planes[a].polygon.containsPoint(newArea.polygon.outerBoundary().coord(i)))
                            {
                                x++;
                            }
                            if(x == numC) {
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
                }
                 function applyOffset(plane, amount) {
                    //apply offset of amount
                }

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
