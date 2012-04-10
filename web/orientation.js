/*
 * Function to draw orientation line on the roof plane
 */
var orientationCenterX = 0;
var orientationCenterY = 0;
var orientationEndX, baseEndX = 0;
var orientationEndY, baseEndY = 0;
var currentPlaneId = -1;
var currentArea = null;
//Represents the draggable point
var tempOrientationPlacemark = null;
var indexPlacemark = 0;
//Radius of the orientation tool circle
var orientationRadius = 0.00002;
//Represents the arm of the tool - the draggable line
var tempOrientationPolyPlacemark = null;
//Temp placemark
var newTempOrientationPolyPlacemark;
//Represents the circle
var orientationCirclePlacemark;
//Represents the base arm that is pointed to south
var tempBasePlacemark;
var isOrientationUIToolActive = false;
function drawOrientationLine(id) {
    var currentAreaIndex;
    for(var a in AreaList) {
        if((AreaList[a].areaType == 'plane')&&(AreaList[a].id == id)) {
            currentArea = AreaList[a];
            currentAreaIndex = a;
        }
    }

    if(currentArea != null) {

        //Removing previously existing orientation placemarks
        var center = currentArea.polygon.outerBoundary().bounds().center();
        orientationCenterX = center.lat();
        orientationCenterY = center.lng();

        var orientationCoords = [];
        var centerCoord = new geo.Point(orientationCenterX, orientationCenterY);
       // var endCoord = new geo.Point(orientationEndX, orientationEndY);

        orientationCoords.push(centerCoord);
        //
       // 
        //
        if(!tempBasePlacemark) {
            var baseCoords = [];
            baseEndX = orientationCenterX - orientationRadius;
            baseEndY = orientationCenterY ;

            baseCoords.push(centerCoord);
            baseCoords.push(new geo.Point(baseEndX, baseEndY));

            tempBasePlacemark = gex.dom.addPolygonPlacemark(baseCoords, {
             //   id: "orientationBaseId_" +currentArea.id ,
                style: {
                    poly: '#00f',
                    line: {
                        width: 3,
                        color: '#00f'
                    }
                }
            });
              ge.getFeatures().appendChild(tempBasePlacemark);
         //   gex.edit.drawLineString(tempBasePlacemark.getGeometry().getOuterBoundary());
           // gex.edit.endEditLineString(tempBasePlacemark.getGeometry().getOuterBoundary());
    createCirclePolygon(center, orientationRadius,currentArea.placemarkId);
    }

        if(currentArea.orientation <= 0) {
            orientationEndX = orientationCenterX - orientationRadius;
            orientationEndY = orientationCenterY;


        } else {
            //remove old placemarks if any
            if(tempOrientationPolyPlacemark) {
                    gex.dom.removeObject(tempOrientationPolyPlacemark);
                    tempOrientationPolyPlacemark = null;
                    orientationCoords = [];
                    orientationCoords.push(centerCoord);
                }


            var angleToSet = currentArea.orientation;
            if(angleToSet < 90) {
                angleToSet = angleToSet+270;
            } else {
                angleToSet = angleToSet-90;
            }
            orientationEndX = (Math.sin(angleToSet * 0.0174532925) * orientationRadius ) + orientationCenterX;
            orientationEndY = (Math.cos(angleToSet * 0.0174532925) * orientationRadius ) + orientationCenterY;
            orientationCoords.push(new geo.Point(orientationEndX,orientationEndY));
            newTempOrientationPolyPlacemark = gex.dom.addPolygonPlacemark(orientationCoords, {
                    style: {
                        poly: {
                            fill : false
                        },

                        line: {
                            width: 2,
                            color: '#00f'
                        }
                    }
                });

                tempOrientationPolyPlacemark =newTempOrientationPolyPlacemark;
                ge.getFeatures().appendChild(tempOrientationPolyPlacemark);
               // gex.edit.endEditLineString(tempOrientationPolyPlacemark.getGeometry().getOuterBoundary());


        }

        //remove old placemarks if any
        if(tempOrientationPlacemark) {
            gex.dom.removeObject(tempOrientationPlacemark);
        }
        var p = ge.createPoint('');
        p.setLatitude(orientationEndX);
        p.setLongitude(orientationEndY);
        tempOrientationPlacemark = ge.createPlacemark('');

        // Create style map for placemark
        var icon = ge.createIcon('');
        icon.setHref('http://maps.google.com/mapfiles/kml/shapes/placemark_circle.png');
        var style = ge.createStyle('');
        style.getIconStyle().setIcon(icon);
        tempOrientationPlacemark.setStyleSelector(style);

        tempOrientationPlacemark.setGeometry(p);

        ge.getFeatures().appendChild(tempOrientationPlacemark);
        
        var dragOptions = {
            bounce: false,
            dropCallback: function() {
                //alert('dragged');
                orientationCoords = [];
                    orientationCoords.push(centerCoord);
                if(tempOrientationPolyPlacemark) {
                    gex.dom.removeObject(tempOrientationPolyPlacemark);
                    tempOrientationPolyPlacemark = null;
                    orientationCoords = [];
                    orientationCoords.push(centerCoord);
                }

orientationEndX = tempOrientationPlacemark.getGeometry().getLatitude();
                orientationEndY = tempOrientationPlacemark.getGeometry().getLongitude();

                 

                orientationCoords.push(new geo.Point(orientationEndX,orientationEndY));

                newTempOrientationPolyPlacemark = gex.dom.addPolygonPlacemark(orientationCoords, {
                    style: {
                        poly: {
                            fill : false
                        },

                        line: {
                            width: 2,
                            color: '#00f'
                        }
                    }
                });

                tempOrientationPolyPlacemark =newTempOrientationPolyPlacemark;
                ge.getFeatures().appendChild(tempOrientationPolyPlacemark);
               // gex.edit.endEditLineString(tempOrientationPolyPlacemark.getGeometry().getOuterBoundary());

                //Update area orientation
                //p1 - center, p2 - base, p3 - orientationend
                var p1 = centerCoord;
                var p2 = new geo.Point(baseEndX,baseEndY);
                var p3 = new geo.Point(orientationEndX,orientationEndY);
                var p1p2 = geo.math.distance(p1, p2);
                var p2p3 = geo.math.distance(p2, p3);
                var p3p1 = geo.math.distance(p3, p1);
               var orientationAngle = Math.acos((p1p2*p1p2 + p3p1*p3p1 - p2p3*p2p3)/(2*p1p2*p3p1)).toDegrees();
                if(orientationEndY < baseEndY) {
                    orientationAngle = 360-orientationAngle;
                }
                AreaList[currentAreaIndex].orientation = Math.round(orientationAngle);
                refreshAreaListUI();
            }
        };

        gex.edit.makeDraggable(tempOrientationPlacemark, dragOptions);



    }
    return false;
}

function dragPoint() {

}

   
function createCirclePolygon(center,radius, id) {
  function makeCircle() {

    var ring = ge.createLinearRing('');
    var steps = 25;
    var pi2 = Math.PI * 2;
    for (var i = 0; i < steps; i++) {
      var lat = center.lat()  + radius * Math.cos(i / steps * pi2);
      var lng = center.lng()  + radius * Math.sin(i / steps * pi2);
      ring.getCoordinates().pushLatLngAlt(lat, lng, 0);
    }
    return ring;
  }

  orientationCirclePlacemark = gex.dom.addPolygonPlacemark(makeCircle(), {
      //id:"orientationCircle_"+ id,
                    style: {
                        poly: {
                            fill : false
                        },

                        line: {
                            width: 2,
                            color: '#fff'
                        }
                    }
                });
  ge.getFeatures().appendChild(orientationCirclePlacemark);
}