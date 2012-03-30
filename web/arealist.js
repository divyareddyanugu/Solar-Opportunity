/* 
 Functions to draw and edit the Area List (list of all planes and obstructions)
 */

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
var newOrientation = 0;
var newRise = 0;
var newRun = 0;

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
    this.placemarkId = -1;
    this.orientation = 0;
    this.rise = 0;
    this.run = 0;
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

function drawPoly(areaType) {
    var drawColor = '#0f0';
    var polyColor = '8000ff00';
    if(areaType == "plane") {
        isPlaneActive = true;
        editPlaneMode();
        drawColor = '#0f0';
    }
    else if (areaType == "obstruction") {
        isObsActive = true;
        editObstructionMode();
        drawColor = '#f00';
        polyColor = '800000ff';
    }
    polyPlacemark = gex.dom.addPolygonPlacemark([], {
        id: "id_" + placemarkId++,
        style: {
            poly: polyColor,
            line: {
                width: 3,
                color: drawColor
            }
        }
    });
    gex.edit.drawLineString(polyPlacemark.getGeometry().getOuterBoundary());

}

function undoLastArea() {
    gex.dom.removeObject(polyPlacemark);
    gex.edit.endEditLineString(polyPlacemark.getGeometry().getOuterBoundary());
    polyPlacemark = null;
    defaultPlaneMode();
    defaultObstructionMode();

}

function undoLastPoint(areaType){
    var drawColor = '#0f0';
    var polyColor = '8000ff00';
    if(areaType == "plane") {
        drawColor = '#0f0';
    }
    else if (areaType == "obstruction") {
        drawColor = '#f00';
        polyColor = '800000ff';
    }


    var tempCoords = [];
    var coords = polyPlacemark.getGeometry().getOuterBoundary().getCoordinates();
    if (coords) {
        var n = coords.getLength();
        for (var i = n-2; i >= 0; i--) {
            tempCoords.push(coords.get(i));
        }
    }
   // var tempId = polyPlacemark.getId();
    gex.dom.removeObject(polyPlacemark);
    gex.edit.endEditLineString(polyPlacemark.getGeometry().getOuterBoundary());

    var tempPlacemark = gex.dom.addPolygonPlacemark(tempCoords, {
        id: "id_" +placemarkId++ ,
        style: {
            poly: polyColor,
            line: {
                width: 3,
                color: drawColor
            }
        }
    });
    ge.getFeatures().appendChild(tempPlacemark);
    polyPlacemark = null;

    polyPlacemark = tempPlacemark;
    gex.edit.drawLineString(polyPlacemark.getGeometry().getOuterBoundary());


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
        alert('No polygon to stop drawing!');
        return;
    }
    else if(polyPlacemark.getGeometry().getOuterBoundary().getCoordinates().getLength() < 3) {
        alert('Polygon should have atleast 3 points');
        return;
    }
    else {
        gex.edit.endEditLineString(polyPlacemark.getGeometry().getOuterBoundary());

        addToAreaList(polyPlacemark, areaType);
        //Add Mousedown event listener
        addGEEventListener();

        //Disable undo button
        if(areaType == "plane") {
            isPlaneActive = false;
            defaultPlaneMode();
        } else if(areaType == "obstruction") {
            isObsActive = false;
            defaultObstructionMode();
        }


    }
    
}

/**
 * Returns the object in the DOM with the given ID, or null if
 * none was found.
 */
function getObjectById(id) {
    var foundObject = null;

    // Traverse the DOM, looking for the object with the given ID.
    gex.dom.walk({
        rootObject: ge,
        visitCallback: function() {
            if ('getId' in this && this.getId() == id) {
                foundObject = this;
                return false;  // Stop the walk.
            }
        }
    });

    return foundObject;
}

function addGEEventListener() {
    //Add click event listener to the plane
    google.earth.addEventListener(polyPlacemark, 'mousedown', function(event) {
        // prevent the default balloon from popping up
        event.preventDefault();

        var balloon = ge.createHtmlDivBalloon('');


        balloon.setFeature(event.getTarget());
        balloon.setMaxWidth(300);

        if(isPlaneActive || isObsActive) {
        // alert("You are currently editing a polygon. Select a plane after clicking 'Finish'.");
        } else {
            // Get the plane the point belongs to
                           
            var tempArea = liesInArea(new geo.Point(event.getLatitude(),event.getLongitude()));
            var id = tempArea.placemarkId;
            if(tempArea != -1) {
                var div = document.createElement('DIV');
                div.innerHTML = constructBalloon(tempArea, id);
                                
                balloon.setContentDiv(div);
                ge.setBalloon(balloon);

                               
            }
        }
    });

}

function constructBalloon(selectedArea, objId) {
    var areaType, areaCalculated, orientationString;
    if(selectedArea.areaType == 'plane') {
        areaType = 'ROOF SEGMENT ' + selectedArea.id;
        areaCalculated = selectedArea.area;
        orientationString = "<tr> <td class='balloon_tr'> Orientation </td> <td> " +
        " <input id='orientation" +selectedArea.id+ "' type='text' "+
        "onchange=\"validateOrientation("+selectedArea.id +",this.value );\" maxlength='3' "+
        "title='Angle of the roof in degrees. Value lies between 0 & 360 degrees.' " +
        " style=\"width:30px;\" value='"+selectedArea.orientation+"'/> degrees </td> </tr>" +
        "<tr> <td class='balloon_tr'> Slope </td> <td>" +
        "<input id='rise" +selectedArea.id+ "' " +
        "onchange=\"validateRise("+selectedArea.id +",this.value );\" maxlength='2' "+
        "title='Roof pitch is a numerical measure of the steepness of a roof. See Help for more info.' " +
        " type=text style='width:20px;' value='"+selectedArea.rise+"'/>  ft / <input id='run" +selectedArea.id+ "' "+
        "onchange=\"validateRun("+selectedArea.id +",this.value );\" maxlength='2' "+
        "title='Roof pitch is a numerical measure of the steepness of a roof. See Help for more info.' " +
        " type=text style='width:20px;' value='"+selectedArea.run+"'/>  ft  (rise/run) " +
        "</td></tr>";
    } else if(selectedArea.areaType == 'obstruction') {
        areaType = 'UNUSABLE AREA';
        areaCalculated = selectedArea.area;
        orientationString = "";
    }

    var balloonContent = "<table width='300' border='0' height=auto> <tr> <td colspan='2' class='balloon_title'> " +
    areaType + " </td> </tr> <tr> <td class='balloon_tr'>" +
    "Area </td> <td>" + areaCalculated + " Sq. Ft    </td> </tr>" +
    orientationString +
    "<tr> <td colspan=2 class='balloon_submit'> " +
    "<input id='delete"+selectedArea.id+"' type='submit' value='Delete' "+
    "onclick=\"gex.dom.removeObject(gex.dom.getObjectById('"+objId+"'));removeFromAreaList('"+objId+"');ge.setBalloon(null);return false;\"/>" +
    "<input id='clear"+selectedArea.id+"' type='submit' value='Cancel' onclick=\"cancelChanges("+selectedArea.id+");return false;\"/>";
    if(selectedArea.areaType == 'plane'){
        balloonContent += "<input id='update"+selectedArea.id+"' type='submit' value='Update' onclick=\"updateChanges('"+selectedArea.id+"');return false;\"/>";
    }
    balloonContent += "</tr> </tr> </table> ";

    return balloonContent;
}

function deletePoly(placemarkId) {

    gex.dom.removeObject(gex.dom.getObjectById(placemarkId));

}

function liesInArea(coord) {
    var planeList = getPlanes();
    var obsList = getObstructions();
    for(var a in planeList) {
        if (planeList[a].polygon.containsPoint(coord)) {
            //Check if point is in obstruction
            for (var b in obsList) {
                if (obsList[b].polygon.containsPoint(coord)) {
            
                    return obsList[b];
                }
            }
            return planeList[a];
        }
    }
    return -1;
}


function cancelChanges(planeId) {
    // No changes needed. Close the balloon
    ge.setBalloon(null);
}

function updateChanges(planeId) {
    for(var u in AreaList) {
        if((AreaList[u].id == planeId)&& (AreaList[u].areaType == "plane")) {
            AreaList[u].orientation = newOrientation;
            AreaList[u].rise = newRise;
            AreaList[u].run = newRun;
            alert("New orientation & slope values saved.");
            refreshAreaListUI();
        }
    }
}

// Add new area to the area list
function addToAreaList(polyPlacemark, areaType) {
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
    newArea.placemarkId = polyPlacemark.getId();

    //Update UI
    if(areaType == "plane") {
        //planeCount = planeCount + 1;
        planeCount = getPlanes().length;
        newArea.id = planeCount+1;
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
            alert("Unusable area must lie entirely in one roof segment");
            undoLastArea();
        }
    }
    refreshAreaListUI();
}

// Remove area from the area list
function removeFromAreaList(deletedAreaPlacemarkId) {
    for(var i in AreaList) {
        if(AreaList[i].placemarkId == deletedAreaPlacemarkId) {
            //If the removed area is an obstruction, then upadate the parent plane's effective area
            if(AreaList[i].areaType == "obstruction") {
                
                    for (var j in AreaList) {
                        if(AreaList[j].id == AreaList[i].refPlaneId) {
                            AreaList[j].effectiveArea += AreaList[i].area;
                        }
                    }
                    AreaList.splice(i,1);
                    refreshAreaListUI();
                
            } else if (AreaList[i].areaType == "plane") {
                var tempId = AreaList[i].id;
                var hasObstructions = false;
                //The removed area is a plane, so delete all the obstructions related to it
                for(var k in AreaList) {
                    if((AreaList[k].areaType == "obstruction") && (AreaList[k].refPlaneId == tempId)) {
                        deletePoly(AreaList[k].placemarkId);
                        removeFromAreaList(AreaList[k].placemarkId);
                        hasObstructions = true;
                    }
                }
                AreaList.splice(i,1);
                if(hasObstructions) {
                    alert("Unusable areas related to this roof segment are also deleted");
                }
refreshAreaListUI();
updatePlaneIds();
                
            }
            

            
            return true;
        }
    }
    return false;
}

function updateEffectivePlaneArea(id, area) {
    for(var i in AreaList) {
        if(AreaList[i].id == id) {
            AreaList[i].effectiveArea -=roundNumber(area,2);
        }
    }
}

function updatePlaneIds() {
    var pid = 1;
 var newPid = -1;
    for(var p in AreaList) {
        if(AreaList[p].areaType == "plane") {
            newPid = pid++;
            //Update RefPlaneIds of all obstructions that belong to this plane
            for(var o in AreaList) {
                if((AreaList[o].areaType == "obstruction") && (AreaList[o].refPlaneId == AreaList[p].id)) {
                    AreaList[o].refPlaneId = newPid;
                }
            }
            AreaList[p].id = newPid;
        }
    }
}

function refreshAreaListUI() {
    clearAreaUIHtml();
  //  updatePlaneIds();
    var totalArea = 0;
    PlaneList = getPlanes();
    ObsList = getObstructions();
   // document.getElementById('area-ui').innerHTML += "<table>";
    for(var a in PlaneList) {
        document.getElementById('area-ui').innerHTML += "<span class='span_title'>Roof Segment " + PlaneList[a].id + " </span> " +
            "<span class='span_subtitle'>Area </span> <span class='span_text'>&nbsp;"+ roundNumber(PlaneList[a].area,2) + " <i>SqFt</i> </span> " +
        "<span class='span_subtitle'>&nbsp;&nbsp;&nbsp;Orientation </span> <span class='span_text'>&nbsp;" +PlaneList[a].orientation+ " <i>degrees</i> </span>" +
        "<span class='span_subtitle'>&nbsp;&nbsp;&nbsp;Slope </span> <span class='span_text'>&nbsp;" +PlaneList[a].rise+ " <i>ft</i> / "+
        PlaneList[a].run+ " <i>ft  (rise/run)</i> </span>";

        totalArea += PlaneList[a].effectiveArea;
        // Check obstructions related to the plane
        for(var b in ObsList) {
            if(ObsList[b].refPlaneId == PlaneList[a].id) {
                document.getElementById('area-ui').innerHTML += "<span class='span_subtitle'>Unusable Area </span> <span class='span_text'>&nbsp;" + roundNumber(ObsList[b].area,2) + " <i>SqFt</i>  </span> ";
            }
        }
        document.getElementById('area-ui').innerHTML += "<span class='span_subtitle'>Usable Area </span> <span class='span_text'>&nbsp;" +
            roundNumber(PlaneList[a].effectiveArea,2) + " <i>SqFt</i> </span>";

  //     document.getElementById('area-ui').innerHTML += "<p style=\"border-bottom: 1px dotted #000000; width: 260px;\"> <br/>";
    }
    document.getElementById('area-ui').innerHTML += "  "+
        "<h2 class='span_summary'>Total Usable Area</h2> <span class='span_summarytext'>&nbsp;" + roundNumber(totalArea,2) +" <i>SqFt</i> </span> ";


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
            if (planes[a].polygon.containsPoint(newArea.polygon.outerBoundary().coord(i))) {
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
    defaultPlaneMode();
    defaultObstructionMode();
    isPlaneActive = false; isObsActive = false;
    AreaList = new Array();
    planeCount = 0;
}
function applyOffset(plane, amount) {
//apply offset of amount
}

/*
 * Validate user input data
 */

function validateOrientation(id, value){
    if((value >= 0) && (value <= 360)) {
        newOrientation = value;
    } else {
        document.getElementById("orientation" + id).value = "";
        alert("Invalid orientation value");
    }
}

function validateRun(id, value) {

    if((value >= 0) && (value <= 99)) {
        newRun = value;
    } else {
        document.getElementById("run" + id).value = "";
        alert("Invalid run value");
    }
}
function validateRise(id, value) {
    if((value >= 0) && (value <= 99)) {
        newRise = value;
    } else {
        document.getElementById("rise" + id).value = "";
        alert("Invalid rise value");
    }

}

