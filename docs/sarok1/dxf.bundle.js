var __getOwnPropNames = Object.getOwnPropertyNames;
var __commonJS = (cb, mod) => function __require() {
  return mod || (0, cb[__getOwnPropNames(cb)[0]])((mod = { exports: {} }).exports, mod), mod.exports;
};

// node_modules/dxf/lib/config.js
var require_config = __commonJS({
  "node_modules/dxf/lib/config.js"(exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", {
      value: true
    });
    exports["default"] = void 0;
    var _default = exports["default"] = {
      verbose: false
    };
  }
});

// node_modules/dxf/lib/handlers/header.js
var require_header = __commonJS({
  "node_modules/dxf/lib/handlers/header.js"(exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", {
      value: true
    });
    exports["default"] = void 0;
    var _default = exports["default"] = function _default2(tuples) {
      var state;
      var header = {};
      tuples.forEach(function(tuple) {
        var type = tuple[0];
        var value = tuple[1];
        switch (value) {
          case "$MEASUREMENT": {
            state = "measurement";
            break;
          }
          case "$INSUNITS": {
            state = "insUnits";
            break;
          }
          case "$EXTMIN":
            header.extMin = {};
            state = "extMin";
            break;
          case "$EXTMAX":
            header.extMax = {};
            state = "extMax";
            break;
          case "$DIMASZ":
            header.dimArrowSize = {};
            state = "dimArrowSize";
            break;
          default:
            switch (state) {
              case "extMin":
              case "extMax": {
                switch (type) {
                  case 10:
                    header[state].x = value;
                    break;
                  case 20:
                    header[state].y = value;
                    break;
                  case 30:
                    header[state].z = value;
                    state = void 0;
                    break;
                }
                break;
              }
              case "measurement":
              case "insUnits": {
                switch (type) {
                  case 70: {
                    header[state] = value;
                    state = void 0;
                    break;
                  }
                }
                break;
              }
              case "dimArrowSize": {
                switch (type) {
                  case 40: {
                    header[state] = value;
                    state = void 0;
                    break;
                  }
                }
                break;
              }
            }
        }
      });
      return header;
    };
  }
});

// node_modules/dxf/lib/util/logger.js
var require_logger = __commonJS({
  "node_modules/dxf/lib/util/logger.js"(exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", {
      value: true
    });
    exports["default"] = void 0;
    var _config = _interopRequireDefault(require_config());
    function _interopRequireDefault(e) {
      return e && e.__esModule ? e : { "default": e };
    }
    function info() {
      if (_config["default"].verbose) {
        console.info.apply(void 0, arguments);
      }
    }
    function warn() {
      if (_config["default"].verbose) {
        console.warn.apply(void 0, arguments);
      }
    }
    function error() {
      console.error.apply(void 0, arguments);
    }
    var _default = exports["default"] = {
      info,
      warn,
      error
    };
  }
});

// node_modules/dxf/lib/handlers/tables.js
var require_tables = __commonJS({
  "node_modules/dxf/lib/handlers/tables.js"(exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", {
      value: true
    });
    exports["default"] = void 0;
    var _logger = _interopRequireDefault(require_logger());
    function _interopRequireDefault(e) {
      return e && e.__esModule ? e : { "default": e };
    }
    var ltypeHandler = function ltypeHandler2(tuples) {
      var element = null;
      var offset = null;
      return tuples.reduce(function(layer, tuple) {
        var type = tuple[0];
        var value = tuple[1];
        switch (type) {
          case 2:
            layer.name = value;
            break;
          case 3:
            layer.description = value;
            break;
          case 70:
            layer.flag = value;
            break;
          case 72:
            layer.alignment = value;
            break;
          case 73:
            layer.elementCount = parseInt(value);
            break;
          case 40:
            layer.patternLength = value;
            break;
          case 49:
            {
              element = /* @__PURE__ */ Object.create({
                scales: [],
                offset: []
              });
              element.length = value;
              layer.pattern.push(element);
            }
            break;
          case 74:
            element.shape = value;
            break;
          case 75:
            element.shapeNumber = value;
            break;
          case 340:
            element.styleHandle = value;
            break;
          case 46:
            element.scales.push(value);
            break;
          case 50:
            element.rotation = value;
            break;
          case 44:
            offset = /* @__PURE__ */ Object.create({
              x: value,
              y: 0
            });
            element.offset.push(offset);
            break;
          case 45:
            offset.y = value;
            break;
          case 9:
            element.text = value;
            break;
          default:
        }
        return layer;
      }, {
        type: "LTYPE",
        pattern: []
      });
    };
    var layerHandler = function layerHandler2(tuples) {
      return tuples.reduce(function(layer, tuple) {
        var type = tuple[0];
        var value = tuple[1];
        switch (type) {
          case 2:
            layer.name = value;
            break;
          case 6:
            layer.lineTypeName = value;
            break;
          case 62:
            layer.colorNumber = value;
            break;
          case 70:
            layer.flags = value;
            break;
          case 290:
            layer.plot = parseInt(value) !== 0;
            break;
          case 370:
            layer.lineWeightEnum = value;
            break;
          default:
        }
        return layer;
      }, {
        type: "LAYER"
      });
    };
    var styleHandler = function styleHandler2(tuples) {
      return tuples.reduce(function(style, tuple) {
        var type = tuple[0];
        var value = tuple[1];
        switch (type) {
          case 2:
            style.name = value;
            break;
          case 6:
            style.lineTypeName = value;
            break;
          case 40:
            style.fixedTextHeight = value;
            break;
          case 41:
            style.widthFactor = value;
            break;
          case 50:
            style.obliqueAngle = value;
            break;
          case 71:
            style.flags = value;
            break;
          case 42:
            style.lastHeightUsed = value;
            break;
          case 3:
            style.primaryFontFileName = value;
            break;
          case 4:
            style.bigFontFileName = value;
            break;
          default:
        }
        return style;
      }, {
        type: "STYLE"
      });
    };
    var vPortHandler = function vPortHandler2(tuples) {
      return tuples.reduce(function(vport, tuple) {
        var type = tuple[0];
        var value = tuple[1];
        switch (type) {
          case 2:
            vport.name = value;
            break;
          case 5:
            vport.handle = value;
            break;
          case 70:
            vport.flags = value;
            break;
          case 10:
            vport.lowerLeft.x = parseFloat(value);
            break;
          case 20:
            vport.lowerLeft.y = parseFloat(value);
            break;
          case 11:
            vport.upperRight.x = parseFloat(value);
            break;
          case 21:
            vport.upperRight.y = parseFloat(value);
            break;
          case 12:
            vport.center.x = parseFloat(value);
            break;
          case 22:
            vport.center.y = parseFloat(value);
            break;
          case 14:
            vport.snapSpacing.x = parseFloat(value);
            break;
          case 24:
            vport.snapSpacing.y = parseFloat(value);
            break;
          case 15:
            vport.gridSpacing.x = parseFloat(value);
            break;
          case 25:
            vport.gridSpacing.y = parseFloat(value);
            break;
          case 16:
            vport.direction.x = parseFloat(value);
            break;
          case 26:
            vport.direction.y = parseFloat(value);
            break;
          case 36:
            vport.direction.z = parseFloat(value);
            break;
          case 17:
            vport.target.x = parseFloat(value);
            break;
          case 27:
            vport.target.y = parseFloat(value);
            break;
          case 37:
            vport.target.z = parseFloat(value);
            break;
          case 45:
            vport.height = parseFloat(value);
            break;
          case 50:
            vport.snapAngle = parseFloat(value);
            break;
          case 51:
            vport.angle = parseFloat(value);
            break;
          case 110:
            vport.x = parseFloat(value);
            break;
          case 120:
            vport.y = parseFloat(value);
            break;
          case 130:
            vport.z = parseFloat(value);
            break;
          case 111:
            vport.xAxisX = parseFloat(value);
            break;
          case 121:
            vport.xAxisY = parseFloat(value);
            break;
          case 131:
            vport.xAxisZ = parseFloat(value);
            break;
          case 112:
            vport.xAxisX = parseFloat(value);
            break;
          case 122:
            vport.xAxisY = parseFloat(value);
            break;
          case 132:
            vport.xAxisZ = parseFloat(value);
            break;
          case 146:
            vport.elevation = parseFloat(value);
            break;
          default:
        }
        return vport;
      }, {
        type: "VPORT",
        center: {},
        lowerLeft: {},
        upperRight: {},
        snap: {},
        snapSpacing: {},
        gridSpacing: {},
        direction: {},
        target: {}
      });
    };
    var tableHandler = function tableHandler2(tuples, tableType, handler) {
      var tableRowsTuples = [];
      var tableRowTuples;
      tuples.forEach(function(tuple) {
        var type = tuple[0];
        var value = tuple[1];
        if ((type === 0 || type === 2) && value === tableType) {
          tableRowTuples = [];
          tableRowsTuples.push(tableRowTuples);
        } else {
          tableRowTuples.push(tuple);
        }
      });
      return tableRowsTuples.reduce(function(acc, rowTuples) {
        var tableRow = handler(rowTuples);
        if (tableRow.name) {
          acc[tableRow.name] = tableRow;
        } else {
          _logger["default"].warn("table row without name:", tableRow);
        }
        return acc;
      }, {});
    };
    var _default = exports["default"] = function _default2(tuples) {
      var tableGroups = [];
      var tableTuples;
      tuples.forEach(function(tuple) {
        var value = tuple[1];
        if (value === "TABLE") {
          tableTuples = [];
          tableGroups.push(tableTuples);
        } else if (value === "ENDTAB") {
          tableGroups.push(tableTuples);
        } else {
          tableTuples.push(tuple);
        }
      });
      var stylesTuples = [];
      var layersTuples = [];
      var vPortTuples = [];
      var ltypeTuples = [];
      tableGroups.forEach(function(group) {
        if (group[0][1] === "STYLE") {
          stylesTuples = group;
        } else if (group[0][1] === "LTYPE") {
          ltypeTuples = group;
        } else if (group[0][1] === "LAYER") {
          layersTuples = group;
        } else if (group[0][1] === "VPORT") {
          vPortTuples = group;
        }
      });
      return {
        layers: tableHandler(layersTuples, "LAYER", layerHandler),
        styles: tableHandler(stylesTuples, "STYLE", styleHandler),
        vports: tableHandler(vPortTuples, "VPORT", vPortHandler),
        ltypes: tableHandler(ltypeTuples, "LTYPE", ltypeHandler)
      };
    };
  }
});

// node_modules/dxf/lib/handlers/entity/common.js
var require_common = __commonJS({
  "node_modules/dxf/lib/handlers/entity/common.js"(exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", {
      value: true
    });
    exports["default"] = void 0;
    var _default = exports["default"] = function _default2(type, value) {
      switch (type) {
        case 5: {
          return {
            handle: value
          };
        }
        case 6:
          return {
            lineTypeName: value
          };
        case 8:
          return {
            layer: value
          };
        case 48:
          return {
            lineTypeScale: value
          };
        case 60:
          return {
            visible: value === 0
          };
        case 62:
          return {
            colorNumber: value
          };
        case 67:
          return value === 0 ? {} : {
            paperSpace: value
          };
        case 68:
          return {
            viewportOn: value
          };
        case 69:
          return {
            viewport: value
          };
        case 210:
          return {
            extrusionX: value
          };
        case 220:
          return {
            extrusionY: value
          };
        case 230:
          return {
            extrusionZ: value
          };
        case 410:
          return {
            layout: value
          };
        default:
          return {};
      }
    };
  }
});

// node_modules/dxf/lib/handlers/entity/point.js
var require_point = __commonJS({
  "node_modules/dxf/lib/handlers/entity/point.js"(exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", {
      value: true
    });
    exports.process = exports["default"] = exports.TYPE = void 0;
    var _common = _interopRequireDefault(require_common());
    function _interopRequireDefault(e) {
      return e && e.__esModule ? e : { "default": e };
    }
    var TYPE = exports.TYPE = "POINT";
    var process = exports.process = function process2(tuples) {
      return tuples.reduce(function(entity, tuple) {
        var type = tuple[0];
        var value = tuple[1];
        switch (type) {
          case 10:
            entity.x = value;
            break;
          case 20:
            entity.y = value;
            break;
          case 30:
            entity.z = value;
            break;
          case 39:
            entity.thickness = value;
            break;
          default:
            Object.assign(entity, (0, _common["default"])(type, value));
            break;
        }
        return entity;
      }, {
        type: TYPE
      });
    };
    var _default = exports["default"] = {
      TYPE,
      process
    };
  }
});

// node_modules/dxf/lib/handlers/entity/line.js
var require_line = __commonJS({
  "node_modules/dxf/lib/handlers/entity/line.js"(exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", {
      value: true
    });
    exports.process = exports["default"] = exports.TYPE = void 0;
    var _common = _interopRequireDefault(require_common());
    function _interopRequireDefault(e) {
      return e && e.__esModule ? e : { "default": e };
    }
    var TYPE = exports.TYPE = "LINE";
    var process = exports.process = function process2(tuples) {
      return tuples.reduce(function(entity, tuple) {
        var type = tuple[0];
        var value = tuple[1];
        switch (type) {
          case 10:
            entity.start.x = value;
            break;
          case 20:
            entity.start.y = value;
            break;
          case 30:
            entity.start.z = value;
            break;
          case 39:
            entity.thickness = value;
            break;
          case 11:
            entity.end.x = value;
            break;
          case 21:
            entity.end.y = value;
            break;
          case 31:
            entity.end.z = value;
            break;
          default:
            Object.assign(entity, (0, _common["default"])(type, value));
            break;
        }
        return entity;
      }, {
        type: TYPE,
        start: {},
        end: {}
      });
    };
    var _default = exports["default"] = {
      TYPE,
      process
    };
  }
});

// node_modules/dxf/lib/handlers/entity/lwpolyline.js
var require_lwpolyline = __commonJS({
  "node_modules/dxf/lib/handlers/entity/lwpolyline.js"(exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", {
      value: true
    });
    exports.process = exports["default"] = exports.TYPE = void 0;
    var _common = _interopRequireDefault(require_common());
    function _interopRequireDefault(e) {
      return e && e.__esModule ? e : { "default": e };
    }
    var TYPE = exports.TYPE = "LWPOLYLINE";
    var process = exports.process = function process2(tuples) {
      var vertex;
      return tuples.reduce(function(entity, tuple) {
        var type = tuple[0];
        var value = tuple[1];
        switch (type) {
          case 70:
            entity.closed = (value & 1) === 1;
            break;
          case 10:
            vertex = {
              x: value,
              y: 0
            };
            entity.vertices.push(vertex);
            break;
          case 20:
            vertex.y = value;
            break;
          case 39:
            entity.thickness = value;
            break;
          case 42:
            vertex.bulge = value;
            break;
          default:
            Object.assign(entity, (0, _common["default"])(type, value));
            break;
        }
        return entity;
      }, {
        type: TYPE,
        vertices: []
      });
    };
    var _default = exports["default"] = {
      TYPE,
      process
    };
  }
});

// node_modules/dxf/lib/handlers/entity/polyline.js
var require_polyline = __commonJS({
  "node_modules/dxf/lib/handlers/entity/polyline.js"(exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", {
      value: true
    });
    exports.process = exports["default"] = exports.TYPE = void 0;
    var _common = _interopRequireDefault(require_common());
    function _interopRequireDefault(e) {
      return e && e.__esModule ? e : { "default": e };
    }
    var TYPE = exports.TYPE = "POLYLINE";
    var process = exports.process = function process2(tuples) {
      return tuples.reduce(function(entity, tuple) {
        var type = tuple[0];
        var value = tuple[1];
        switch (type) {
          case 70:
            entity.closed = (value & 1) === 1;
            entity.polygonMesh = (value & 16) === 16;
            entity.polyfaceMesh = (value & 64) === 64;
            break;
          case 39:
            entity.thickness = value;
            break;
          default:
            Object.assign(entity, (0, _common["default"])(type, value));
            break;
        }
        return entity;
      }, {
        type: TYPE,
        vertices: []
      });
    };
    var _default = exports["default"] = {
      TYPE,
      process
    };
  }
});

// node_modules/dxf/lib/handlers/entity/vertex.js
var require_vertex = __commonJS({
  "node_modules/dxf/lib/handlers/entity/vertex.js"(exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", {
      value: true
    });
    exports.process = exports["default"] = exports.TYPE = void 0;
    var TYPE = exports.TYPE = "VERTEX";
    var ensureFaces = function ensureFaces2(entity) {
      entity.faces = entity.faces || [];
      if ("x" in entity && !entity.x) delete entity.x;
      if ("y" in entity && !entity.y) delete entity.y;
      if ("z" in entity && !entity.z) delete entity.z;
    };
    var process = exports.process = function process2(tuples) {
      return tuples.reduce(function(entity, tuple) {
        var type = tuple[0];
        var value = tuple[1];
        switch (type) {
          case 10:
            entity.x = value;
            break;
          case 20:
            entity.y = value;
            break;
          case 30:
            entity.z = value;
            break;
          case 42:
            entity.bulge = value;
            break;
          case 71:
            ensureFaces(entity);
            entity.faces[0] = value;
            break;
          case 72:
            ensureFaces(entity);
            entity.faces[1] = value;
            break;
          case 73:
            ensureFaces(entity);
            entity.faces[2] = value;
            break;
          case 74:
            ensureFaces(entity);
            entity.faces[3] = value;
            break;
          default:
            break;
        }
        return entity;
      }, {});
    };
    var _default = exports["default"] = {
      TYPE,
      process
    };
  }
});

// node_modules/dxf/lib/handlers/entity/circle.js
var require_circle = __commonJS({
  "node_modules/dxf/lib/handlers/entity/circle.js"(exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", {
      value: true
    });
    exports.process = exports["default"] = exports.TYPE = void 0;
    var _common = _interopRequireDefault(require_common());
    function _interopRequireDefault(e) {
      return e && e.__esModule ? e : { "default": e };
    }
    var TYPE = exports.TYPE = "CIRCLE";
    var process = exports.process = function process2(tuples) {
      return tuples.reduce(function(entity, tuple) {
        var type = tuple[0];
        var value = tuple[1];
        switch (type) {
          case 10:
            entity.x = value;
            break;
          case 20:
            entity.y = value;
            break;
          case 30:
            entity.z = value;
            break;
          case 40:
            entity.r = value;
            break;
          default:
            Object.assign(entity, (0, _common["default"])(type, value));
            break;
        }
        return entity;
      }, {
        type: TYPE
      });
    };
    var _default = exports["default"] = {
      TYPE,
      process
    };
  }
});

// node_modules/dxf/lib/handlers/entity/arc.js
var require_arc = __commonJS({
  "node_modules/dxf/lib/handlers/entity/arc.js"(exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", {
      value: true
    });
    exports.process = exports["default"] = exports.TYPE = void 0;
    var _common = _interopRequireDefault(require_common());
    function _interopRequireDefault(e) {
      return e && e.__esModule ? e : { "default": e };
    }
    var TYPE = exports.TYPE = "ARC";
    var process = exports.process = function process2(tuples) {
      return tuples.reduce(function(entity, tuple) {
        var type = tuple[0];
        var value = tuple[1];
        switch (type) {
          case 10:
            entity.x = value;
            break;
          case 20:
            entity.y = value;
            break;
          case 30:
            entity.z = value;
            break;
          case 39:
            entity.thickness = value;
            break;
          case 40:
            entity.r = value;
            break;
          case 50:
            entity.startAngle = value / 180 * Math.PI;
            break;
          case 51:
            entity.endAngle = value / 180 * Math.PI;
            break;
          default:
            Object.assign(entity, (0, _common["default"])(type, value));
            break;
        }
        return entity;
      }, {
        type: TYPE
      });
    };
    var _default = exports["default"] = {
      TYPE,
      process
    };
  }
});

// node_modules/dxf/lib/handlers/entity/ellipse.js
var require_ellipse = __commonJS({
  "node_modules/dxf/lib/handlers/entity/ellipse.js"(exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", {
      value: true
    });
    exports.process = exports["default"] = exports.TYPE = void 0;
    var _common = _interopRequireDefault(require_common());
    function _interopRequireDefault(e) {
      return e && e.__esModule ? e : { "default": e };
    }
    var TYPE = exports.TYPE = "ELLIPSE";
    var process = exports.process = function process2(tuples) {
      return tuples.reduce(function(entity, tuple) {
        var type = tuple[0];
        var value = tuple[1];
        switch (type) {
          case 10:
            entity.x = value;
            break;
          case 11:
            entity.majorX = value;
            break;
          case 20:
            entity.y = value;
            break;
          case 21:
            entity.majorY = value;
            break;
          case 30:
            entity.z = value;
            break;
          case 31:
            entity.majorZ = value;
            break;
          case 40:
            entity.axisRatio = value;
            break;
          case 41:
            entity.startAngle = value;
            break;
          case 42:
            entity.endAngle = value;
            break;
          default:
            Object.assign(entity, (0, _common["default"])(type, value));
            break;
        }
        return entity;
      }, {
        type: TYPE
      });
    };
    var _default = exports["default"] = {
      TYPE,
      process
    };
  }
});

// node_modules/dxf/lib/handlers/entity/spline.js
var require_spline = __commonJS({
  "node_modules/dxf/lib/handlers/entity/spline.js"(exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", {
      value: true
    });
    exports.process = exports["default"] = exports.TYPE = void 0;
    var _common = _interopRequireDefault(require_common());
    function _interopRequireDefault(e) {
      return e && e.__esModule ? e : { "default": e };
    }
    var TYPE = exports.TYPE = "SPLINE";
    var process = exports.process = function process2(tuples) {
      var controlPoint;
      return tuples.reduce(function(entity, tuple) {
        var type = tuple[0];
        var value = tuple[1];
        switch (type) {
          case 10:
            controlPoint = {
              x: value,
              y: 0
            };
            entity.controlPoints.push(controlPoint);
            break;
          case 20:
            controlPoint.y = value;
            break;
          case 30:
            controlPoint.z = value;
            break;
          case 40:
            entity.knots.push(value);
            break;
          case 41:
            if (!entity.weights) entity.weights = [];
            entity.weights.push(value);
            break;
          case 42:
            entity.knotTolerance = value;
            break;
          case 43:
            entity.controlPointTolerance = value;
            break;
          case 44:
            entity.fitTolerance = value;
            break;
          case 70:
            entity.flag = value;
            entity.closed = (value & 1) === 1;
            break;
          case 71:
            entity.degree = value;
            break;
          case 72:
            entity.numberOfKnots = value;
            break;
          case 73:
            entity.numberOfControlPoints = value;
            break;
          case 74:
            entity.numberOfFitPoints = value;
            break;
          default:
            Object.assign(entity, (0, _common["default"])(type, value));
            break;
        }
        return entity;
      }, {
        type: TYPE,
        controlPoints: [],
        knots: []
      });
    };
    var _default = exports["default"] = {
      TYPE,
      process
    };
  }
});

// node_modules/dxf/lib/handlers/entity/solid.js
var require_solid = __commonJS({
  "node_modules/dxf/lib/handlers/entity/solid.js"(exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", {
      value: true
    });
    exports.process = exports["default"] = exports.TYPE = void 0;
    var _common = _interopRequireDefault(require_common());
    function _interopRequireDefault(e) {
      return e && e.__esModule ? e : { "default": e };
    }
    var TYPE = exports.TYPE = "SOLID";
    var process = exports.process = function process2(tuples) {
      return tuples.reduce(function(entity, tuple) {
        var type = tuple[0];
        var value = tuple[1];
        switch (type) {
          case 10:
            entity.corners[0].x = value;
            break;
          case 20:
            entity.corners[0].y = value;
            break;
          case 30:
            entity.corners[0].z = value;
            break;
          case 11:
            entity.corners[1].x = value;
            break;
          case 21:
            entity.corners[1].y = value;
            break;
          case 31:
            entity.corners[1].z = value;
            break;
          case 12:
            entity.corners[2].x = value;
            break;
          case 22:
            entity.corners[2].y = value;
            break;
          case 32:
            entity.corners[2].z = value;
            break;
          case 13:
            entity.corners[3].x = value;
            break;
          case 23:
            entity.corners[3].y = value;
            break;
          case 33:
            entity.corners[3].z = value;
            break;
          case 39:
            entity.thickness = value;
            break;
          default:
            Object.assign(entity, (0, _common["default"])(type, value));
            break;
        }
        return entity;
      }, {
        type: TYPE,
        corners: [{}, {}, {}, {}]
      });
    };
    var _default = exports["default"] = {
      TYPE,
      process
    };
  }
});

// node_modules/dxf/lib/handlers/entity/hatch.js
var require_hatch = __commonJS({
  "node_modules/dxf/lib/handlers/entity/hatch.js"(exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", {
      value: true
    });
    exports.process = exports["default"] = exports.TYPE = void 0;
    var _common = _interopRequireDefault(require_common());
    function _interopRequireDefault(e) {
      return e && e.__esModule ? e : { "default": e };
    }
    var TYPE = exports.TYPE = "HATCH";
    var status = "IDLE";
    var drawEntity = {};
    var drawType = 0;
    var isPolyline = false;
    var seed = null;
    var loop = {
      references: [],
      entities: []
    };
    var polyPoint = null;
    var process = exports.process = function process2(tuples) {
      return tuples.reduce(function(entity, tuple) {
        var type = tuple[0];
        var value = tuple[1];
        switch (type) {
          case 100:
            status = "IDLE";
            break;
          case 2:
            entity.patternName = value;
            break;
          case 10:
            {
              if (status === "IDLE") entity.elevation.x = parseFloat(value);
              else if (status === "POLYLINE") {
                polyPoint = {
                  x: parseFloat(value),
                  y: 0,
                  bulge: 0
                };
                loop.entities[0].points.push(polyPoint);
              } else if (status === "SEED") {
                if (!seed) {
                  seed = {
                    x: 0,
                    y: 0
                  };
                  entity.seeds.seeds.push(seed);
                }
                seed.x = parseFloat(value);
              } else fillDrawEntity(type, drawType, parseFloat(value));
            }
            break;
          case 20:
            {
              if (status === "IDLE") entity.elevation.y = parseFloat(value);
              else if (status === "POLYLINE") polyPoint.y = parseFloat(value);
              else if (status === "SEED") {
                seed.y = parseFloat(value);
                seed = null;
              } else fillDrawEntity(type, drawType, parseFloat(value));
            }
            break;
          case 30:
            entity.elevation.z = parseFloat(value);
            break;
          case 63:
            entity.fillColor = value;
            break;
          case 70:
            entity.fillType = parseFloat(value) === 1 ? "SOLID" : "PATTERN";
            break;
          case 210:
            entity.extrusionDir.x = parseFloat(value);
            break;
          case 220:
            entity.extrusionDir.y = parseFloat(value);
            break;
          case 230:
            entity.extrusionDir.z = parseFloat(value);
            break;
          case 91:
            {
              entity.boundary.count = parseFloat(value);
            }
            break;
          case 92:
            {
              loop = {
                references: [],
                entities: []
              };
              entity.boundary.loops.push(loop);
              loop.type = parseFloat(value);
              isPolyline = (loop.type & 2) === 2;
              if (isPolyline) {
                var ent = {
                  type: "POLYLINE",
                  points: []
                };
                loop.entities.push(ent);
                status = "POLYLINE";
              }
            }
            break;
          case 93:
            {
              if (status === "IDLE") status = "ENT";
              loop.count = parseFloat(value);
            }
            break;
          case 11:
          case 21:
          case 40:
          case 50:
          case 51:
          case 74:
          case 94:
          case 95:
          case 96:
            if (drawType === 4) status = "SPLINE";
            fillDrawEntity(type, drawType, parseFloat(value));
            break;
          case 42:
            {
              if (isPolyline) polyPoint.bulge = parseFloat(value);
              else fillDrawEntity(type, drawType, parseFloat(value));
            }
            break;
          case 72:
            {
              drawType = parseFloat(value);
              loop[isPolyline ? "hasBulge" : "edgeType"] = drawType;
              if (!isPolyline) {
                drawEntity = createDrawEntity(drawType);
                loop.entities.push(drawEntity);
              }
            }
            break;
          case 73:
            {
              if (status === "IDLE" || isPolyline) loop.entities[0].closed = value;
              else fillDrawEntity(type, drawType, parseFloat(value));
            }
            break;
          case 75:
            {
              status = "IDLE";
              entity.style = parseFloat(value);
            }
            break;
          case 76:
            entity.hatchType = parseFloat(value);
            break;
          case 97:
            {
              status = "IDLE";
              isPolyline = false;
              loop.sourceObjects = parseFloat(value);
            }
            break;
          case 98:
            {
              status = "SEED";
              entity.seeds.count = parseFloat(value);
            }
            break;
          case 52:
            entity.shadowPatternAngle = parseFloat(value);
            break;
          case 41:
            entity.spacing = parseFloat(value);
            break;
          case 77:
            entity["double"] = parseFloat(value) === 1;
            break;
          case 78:
            entity.pattern.lineCount = parseFloat(value);
            break;
          case 53:
            entity.pattern.angle = parseFloat(value);
            break;
          case 43:
            entity.pattern.x = parseFloat(value);
            break;
          case 44:
            entity.pattern.y = parseFloat(value);
            break;
          case 45:
            entity.pattern.offsetX = parseFloat(value);
            break;
          case 46:
            entity.pattern.offsetY = parseFloat(value);
            break;
          case 79:
            entity.pattern.dashCount = parseFloat(value);
            break;
          case 49:
            entity.pattern.length.push(value);
            break;
          case 330:
            loop.references.push(value);
            break;
          case 450:
            entity.solidOrGradient = parseFloat(value) === 0 ? "SOLID" : "GRADIENT";
            break;
          case 453:
            entity.color.count = parseFloat(value);
            break;
          case 460:
            entity.color.rotation = value;
            break;
          case 461:
            entity.color.gradient = value;
            break;
          case 462:
            entity.color.tint = value;
            break;
          default:
            Object.assign(entity, (0, _common["default"])(type, value));
            break;
        }
        return entity;
      }, {
        type: TYPE,
        elevation: {},
        extrusionDir: {
          x: 0,
          y: 0,
          z: 1
        },
        pattern: {
          length: []
        },
        boundary: {
          loops: []
        },
        seeds: {
          count: 0,
          seeds: []
        },
        color: {}
      });
    };
    var _default = exports["default"] = {
      TYPE,
      process
    };
    function createDrawEntity(type) {
      if (isPolyline) return {};
      switch (type) {
        case 1:
          return {
            type: "LINE",
            start: {
              x: 0,
              y: 0
            },
            end: {
              x: 0,
              y: 0
            }
          };
        case 2:
          return {
            type: "ARC",
            center: {
              x: 0,
              y: 0
            },
            radius: 0,
            startAngle: 0,
            endAngle: 0,
            counterClockWise: false
          };
        case 3:
          return {
            type: "ELLIPSE",
            center: {
              x: 0,
              y: 0
            },
            startAngle: 0,
            endAngle: 0,
            counterClockWise: false,
            major: {
              x: 0,
              y: 0
            },
            minor: 0
          };
        case 4:
          return {
            type: "SPLINE",
            degree: 0,
            rational: 0,
            periodic: 0,
            knots: {
              count: 0,
              knots: []
            },
            controlPoints: {
              count: 0,
              points: []
            },
            weights: 1
          };
      }
      return {};
    }
    function fillDrawEntity(type, drawType2, value) {
      switch (type) {
        case 10:
          {
            switch (drawType2) {
              case 1:
                {
                  drawEntity.start.x = value;
                }
                break;
              case 2:
                {
                  drawEntity.center.x = value;
                }
                break;
              case 3:
                {
                  drawEntity.center.x = value;
                }
                break;
              case 4:
                {
                  drawEntity.controlPoints.points.push({
                    x: value,
                    y: 0
                  });
                }
                break;
            }
          }
          break;
        case 20: {
          switch (drawType2) {
            case 1:
              {
                drawEntity.start.y = value;
              }
              break;
            case 2:
              {
                drawEntity.center.y = value;
              }
              break;
            case 3:
              {
                drawEntity.center.y = value;
              }
              break;
            case 4:
              {
                drawEntity.controlPoints.points[drawEntity.controlPoints.points.length - 1].y = value;
              }
              break;
          }
          break;
        }
        case 11:
          {
            switch (drawType2) {
              case 1:
                {
                  drawEntity.end.x = value;
                }
                break;
              case 3:
                {
                  drawEntity.major.x = value;
                }
                break;
            }
          }
          break;
        case 21: {
          switch (drawType2) {
            case 1:
              {
                drawEntity.end.y = value;
              }
              break;
            case 3:
              {
                drawEntity.major.y = value;
              }
              break;
          }
          break;
        }
        case 40:
          {
            switch (drawType2) {
              case 2:
                {
                  drawEntity.radius = value;
                }
                break;
              case 3:
                {
                  drawEntity.minor = value;
                }
                break;
              case 4:
                {
                  drawEntity.knots.knots.push(value);
                }
                break;
            }
          }
          break;
        case 42:
          {
            switch (drawType2) {
              case 4:
                {
                  drawEntity.weights = value;
                }
                break;
            }
          }
          break;
        case 50:
          {
            switch (drawType2) {
              case 2:
                {
                  drawEntity.startAngle = value;
                }
                break;
              case 3:
                {
                  drawEntity.startAngle = value;
                }
                break;
            }
          }
          break;
        case 51:
          {
            switch (drawType2) {
              case 2:
                {
                  drawEntity.endAngle = value;
                }
                break;
              case 3:
                {
                  drawEntity.endAngle = value;
                }
                break;
            }
          }
          break;
        case 73:
          {
            switch (drawType2) {
              case 2:
                {
                  drawEntity.counterClockWise = parseFloat(value) === 1;
                }
                break;
              case 3:
                {
                  drawEntity.counterClockWise = parseFloat(value) === 1;
                }
                break;
              case 4:
                {
                  drawEntity.rational = value;
                }
                break;
            }
          }
          break;
        case 74:
          {
            switch (drawType2) {
              case 4:
                {
                  drawEntity.periodic = value;
                }
                break;
            }
          }
          break;
        case 94:
          {
            switch (drawType2) {
              case 4:
                {
                  drawEntity.degree = value;
                }
                break;
            }
          }
          break;
        case 95:
          {
            switch (drawType2) {
              case 4:
                {
                  drawEntity.knots.count = value;
                }
                break;
            }
          }
          break;
        case 96:
          {
            switch (drawType2) {
              case 4:
                {
                  drawEntity.controlPoints.count = value;
                }
                break;
            }
          }
          break;
      }
    }
  }
});

// node_modules/dxf/lib/handlers/entity/mtext.js
var require_mtext = __commonJS({
  "node_modules/dxf/lib/handlers/entity/mtext.js"(exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", {
      value: true
    });
    exports.process = exports["default"] = exports.assign = exports.TYPE = void 0;
    var _common = _interopRequireDefault(require_common());
    function _interopRequireDefault(e) {
      return e && e.__esModule ? e : { "default": e };
    }
    var TYPE = exports.TYPE = "MTEXT";
    var simpleCodes = {
      10: "x",
      20: "y",
      30: "z",
      40: "nominalTextHeight",
      41: "refRectangleWidth",
      71: "attachmentPoint",
      72: "drawingDirection",
      7: "styleName",
      11: "xAxisX",
      21: "xAxisY",
      31: "xAxisZ",
      42: "horizontalWidth",
      43: "verticalHeight",
      73: "lineSpacingStyle",
      44: "lineSpacingFactor",
      90: "backgroundFill",
      420: "bgColorRGB0",
      421: "bgColorRGB1",
      422: "bgColorRGB2",
      423: "bgColorRGB3",
      424: "bgColorRGB4",
      425: "bgColorRGB5",
      426: "bgColorRGB6",
      427: "bgColorRGB7",
      428: "bgColorRGB8",
      429: "bgColorRGB9",
      430: "bgColorName0",
      431: "bgColorName1",
      432: "bgColorName2",
      433: "bgColorName3",
      434: "bgColorName4",
      435: "bgColorName5",
      436: "bgColorName6",
      437: "bgColorName7",
      438: "bgColorName8",
      439: "bgColorName9",
      45: "fillBoxStyle",
      63: "bgFillColor",
      441: "bgFillTransparency",
      75: "columnType",
      76: "columnCount",
      78: "columnFlowReversed",
      79: "columnAutoheight",
      48: "columnWidth",
      49: "columnGutter",
      50: "columnHeights"
    };
    var process = exports.process = function process2(tuples) {
      return tuples.reduce(function(entity, tuple) {
        var type = tuple[0];
        var value = tuple[1];
        assign(entity, type, value);
        return entity;
      }, {
        type: TYPE,
        string: ""
      });
    };
    var assign = exports.assign = function assign2(entity, type, value) {
      if (simpleCodes[type] !== void 0) {
        entity[simpleCodes[type]] = value;
      } else if (type === 1 || type === 3) {
        entity.string += value;
      } else if (type === 50) {
        entity.xAxisX = Math.cos(value);
        entity.xAxisY = Math.sin(value);
      } else {
        Object.assign(entity, (0, _common["default"])(type, value));
      }
      return entity;
    };
    var _default = exports["default"] = {
      TYPE,
      process,
      assign
    };
  }
});

// node_modules/dxf/lib/handlers/entity/text.js
var require_text = __commonJS({
  "node_modules/dxf/lib/handlers/entity/text.js"(exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", {
      value: true
    });
    exports.process = exports["default"] = exports.assign = exports.TYPE = void 0;
    var _common = _interopRequireDefault(require_common());
    function _interopRequireDefault(e) {
      return e && e.__esModule ? e : { "default": e };
    }
    var TYPE = exports.TYPE = "TEXT";
    var simpleCodes = {
      1: "string",
      10: "x",
      20: "y",
      30: "z",
      11: "x2",
      21: "y2",
      31: "z2",
      39: "thickness",
      40: "textHeight",
      41: "relScaleX",
      50: "rotation",
      51: "obliqueAngle",
      7: "styleName",
      71: "mirror",
      72: "hAlign",
      73: "vAlign"
    };
    var process = exports.process = function process2(tuples) {
      return tuples.reduce(function(entity, tuple) {
        var type = tuple[0];
        var value = tuple[1];
        assign(entity, type, value);
        return entity;
      }, {
        type: TYPE,
        string: ""
      });
    };
    var assign = exports.assign = function assign2(entity, type, value) {
      if (simpleCodes[type] !== void 0) {
        entity[simpleCodes[type]] = value;
      } else {
        Object.assign(entity, (0, _common["default"])(type, value));
      }
    };
    var _default = exports["default"] = {
      TYPE,
      process,
      assign
    };
  }
});

// node_modules/dxf/lib/handlers/entity/attdef.js
var require_attdef = __commonJS({
  "node_modules/dxf/lib/handlers/entity/attdef.js"(exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", {
      value: true
    });
    exports.process = exports["default"] = exports.assign = exports.TYPE = void 0;
    var _common = _interopRequireDefault(require_common());
    var _mtext = require_mtext();
    var _text = require_text();
    function _interopRequireDefault(e) {
      return e && e.__esModule ? e : { "default": e };
    }
    var TYPE = exports.TYPE = "ATTDEF";
    var process = exports.process = function process2(tuples) {
      return tuples.reduce(function(entity, tuple) {
        var type = tuple[0];
        var value = tuple[1];
        assign(entity, type, value);
        return entity;
      }, {
        type: TYPE,
        subclassMarker: "AcDbText",
        thickness: 0,
        scaleX: 1,
        mtext: {},
        text: {}
      });
    };
    var assign = exports.assign = function assign2(entity, type, value) {
      switch (type) {
        case 100: {
          entity.subclassMarker = value;
          break;
        }
        case 1:
          switch (entity.subclassMarker) {
            case "AcDbText":
              (0, _text.assign)(entity.text, type, value);
              break;
            case "AcDbMText":
              (0, _mtext.assign)(entity.mtext, type, value);
              break;
          }
          break;
        case 2:
          switch (entity.subclassMarker) {
            case "AcDbAttributeDefinition":
            case "AcDbAttribute":
              entity.tag = value;
              break;
            case "AcDbXrecord":
              entity.attdefFlag = value;
              break;
          }
          break;
        case 3:
          switch (entity.subclassMarker) {
            case "AcDbAttributeDefinition":
              entity.prompt = value;
              break;
            case "AcDbMText":
              (0, _mtext.assign)(entity.mtext, type, value);
              break;
          }
          break;
        case 7:
          switch (entity.subclassMarker) {
            case "AcDbAttributeDefinition":
            case "AcDbAttribute":
              (0, _text.assign)(entity.text, type, value);
              break;
            case "AcDbMText":
              (0, _mtext.assign)(entity.mtext, type, value);
              break;
          }
          break;
        case 10:
          switch (entity.subclassMarker) {
            case "AcDbText":
              (0, _text.assign)(entity.text, type, value);
              break;
            case "AcDbMText":
              (0, _mtext.assign)(entity.mtext, type, value);
              break;
            case "AcDbXrecord":
              entity.x = value;
              break;
          }
          break;
        case 20:
          switch (entity.subclassMarker) {
            case "AcDbText":
              (0, _text.assign)(entity.text, type, value);
              break;
            case "AcDbMText":
              (0, _mtext.assign)(entity.mtext, type, value);
              break;
            case "AcDbXrecord":
              entity.y = value;
              break;
          }
          break;
        case 30:
          switch (entity.subclassMarker) {
            case "AcDbText":
              (0, _text.assign)(entity.text, type, value);
              break;
            case "AcDbMText":
              (0, _mtext.assign)(entity.mtext, type, value);
              break;
            case "AcDbXrecord":
              entity.z = value;
              break;
          }
          break;
        case 11:
          switch (entity.subclassMarker) {
            case "AcDbAttributeDefinition":
            case "AcDbAttribute":
              entity.x2 = value;
              break;
            case "AcDbMText":
              (0, _mtext.assign)(entity.mtext, type, value);
              break;
          }
          break;
        case 21:
          switch (entity.subclassMarker) {
            case "AcDbAttributeDefinition":
            case "AcDbAttribute":
              entity.y2 = value;
              break;
            case "AcDbMText":
              (0, _mtext.assign)(entity.mtext, type, value);
              break;
          }
          break;
        case 31:
          switch (entity.subclassMarker) {
            case "AcDbAttributeDefinition":
            case "AcDbAttribute":
              entity.z2 = value;
              break;
            case "AcDbMText":
              (0, _mtext.assign)(entity.mtext, type, value);
              break;
          }
          break;
        case 39:
          (0, _text.assign)(entity.text, type, value);
          break;
        case 40:
          switch (entity.subclassMarker) {
            case "AcDbText":
              (0, _text.assign)(entity.text, type, value);
              break;
            case "AcDbMText":
              (0, _mtext.assign)(entity.mtext, type, value);
              break;
            case "AcDbXrecord":
              entity.annotationScale = value;
              break;
          }
          break;
        case 41:
          switch (entity.subclassMarker) {
            case "AcDbAttributeDefinition":
            case "AcDbAttribute":
              (0, _text.assign)(entity.text, type, value);
              break;
            case "AcDbMText":
              (0, _mtext.assign)(entity.mtext, type, value);
              break;
          }
          break;
        case 42:
        case 43:
        case 44:
        case 45:
          (0, _mtext.assign)(entity.mtext, type, value);
          break;
        case 46:
          entity.mtext.annotationHeight = value;
          break;
        case 48:
        case 49:
          (0, _mtext.assign)(entity.mtext, type, value);
          break;
        case 50:
          switch (entity.subclassMarker) {
            case "AcDbAttributeDefinition":
            case "AcDbAttribute":
              (0, _text.assign)(entity.text, type, value);
              break;
            case "AcDbMText":
              {
                (0, _mtext.assign)(entity.mtext, type, value);
              }
              break;
          }
          break;
        case 51:
          (0, _text.assign)(entity.text, type, value);
          break;
        case 63:
          (0, _mtext.assign)(entity.mtext, type, value);
          break;
        case 70:
          {
            switch (entity.subclassMarker) {
              case "AcDbAttributeDefinition":
              case "AcDbAttribute":
                entity.attributeFlags = value;
                break;
              case "AcDbXrecord":
                {
                  if (typeof entity.mTextFlag === "undefined") entity.mTextFlag = value;
                  else if (typeof entity.isReallyLocked === "undefined") entity.isReallyLocked = value;
                  else entity.secondaryAttdefCount = value;
                }
                break;
            }
          }
          break;
        case 71:
        case 72:
          switch (entity.subclassMarker) {
            case "AcDbAttributeDefinition":
            case "AcDbAttribute":
              (0, _text.assign)(entity.text, type, value);
              break;
            case "AcDbMText":
              (0, _mtext.assign)(entity.mtext, type, value);
              break;
          }
          break;
        case 73:
          switch (entity.subclassMarker) {
            case "AcDbAttributeDefinition":
            case "AcDbAttribute":
              entity.fieldLength = value;
              break;
            case "AcDbMText":
              (0, _mtext.assign)(entity.mtext, type, value);
              break;
          }
          break;
        case 74:
          (0, _text.assign)(entity.text, 73, value);
          break;
        case 75:
        case 76:
        case 78:
        case 79:
          (0, _mtext.assign)(entity.mtext, type, value);
          break;
        case 90:
          (0, _mtext.assign)(entity.mtext, type, value);
          break;
        case 210:
        case 220:
        case 230:
          switch (entity.subclassMarker) {
            case "AcDbAttributeDefinition":
            case "AcDbAttribute":
              (0, _text.assign)(entity.mtext, type, value);
              break;
            case "AcDbMText":
              (0, _mtext.assign)(entity.mtext, type, value);
              break;
          }
          break;
        case 280:
          {
            switch (entity.subclassMarker) {
              case "AcDbAttributeDefinition":
              case "AcDbAttribute":
                entity.lock = value;
                break;
              case "AcDbXrecord":
                entity.clone = true;
                break;
            }
          }
          break;
        case 340:
          entity.attdefHandle = value;
          break;
        case 420:
        case 421:
        case 422:
        case 423:
        case 424:
        case 425:
        case 426:
        case 427:
        case 428:
        case 429:
        case 430:
        case 431:
        case 432:
        case 433:
        case 434:
        case 435:
        case 436:
        case 437:
        case 438:
        case 439:
        case 441:
          (0, _mtext.assign)(entity.mtext, type, value);
          break;
        default:
          Object.assign(entity, (0, _common["default"])(type, value));
          break;
      }
    };
    var _default = exports["default"] = {
      TYPE,
      process,
      assign
    };
  }
});

// node_modules/dxf/lib/handlers/entity/attrib.js
var require_attrib = __commonJS({
  "node_modules/dxf/lib/handlers/entity/attrib.js"(exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", {
      value: true
    });
    exports.process = exports["default"] = exports.TYPE = void 0;
    var _attdef = require_attdef();
    var TYPE = exports.TYPE = "ATTRIB";
    var process = exports.process = function process2(tuples) {
      return tuples.reduce(function(entity, tuple) {
        var type = tuple[0];
        var value = tuple[1];
        (0, _attdef.assign)(entity, type, value);
        return entity;
      }, {
        type: TYPE,
        subclassMarker: "AcDbText",
        thickness: 0,
        scaleX: 1,
        mtext: {},
        text: {}
      });
    };
    var _default = exports["default"] = {
      TYPE,
      process
    };
  }
});

// node_modules/dxf/lib/handlers/entity/insert.js
var require_insert = __commonJS({
  "node_modules/dxf/lib/handlers/entity/insert.js"(exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", {
      value: true
    });
    exports.process = exports["default"] = exports.TYPE = void 0;
    var _common = _interopRequireDefault(require_common());
    function _interopRequireDefault(e) {
      return e && e.__esModule ? e : { "default": e };
    }
    var TYPE = exports.TYPE = "INSERT";
    var process = exports.process = function process2(tuples) {
      return tuples.reduce(function(entity, tuple) {
        var type = tuple[0];
        var value = tuple[1];
        switch (type) {
          case 2:
            entity.block = value;
            break;
          case 10:
            entity.x = value;
            break;
          case 20:
            entity.y = value;
            break;
          case 30:
            entity.z = value;
            break;
          case 41:
            entity.scaleX = value;
            break;
          case 42:
            entity.scaleY = value;
            break;
          case 43:
            entity.scaleZ = value;
            break;
          case 44:
            entity.columnSpacing = value;
            break;
          case 45:
            entity.rowSpacing = value;
            break;
          case 50:
            entity.rotation = value;
            break;
          case 70:
            entity.columnCount = value;
            break;
          case 71:
            entity.rowCount = value;
            break;
          case 210:
            entity.extrusionX = value;
            break;
          case 220:
            entity.extrusionY = value;
            break;
          case 230:
            entity.extrusionZ = value;
            break;
          default:
            Object.assign(entity, (0, _common["default"])(type, value));
            break;
        }
        return entity;
      }, {
        type: TYPE
      });
    };
    var _default = exports["default"] = {
      TYPE,
      process
    };
  }
});

// node_modules/dxf/lib/handlers/entity/threeDFace.js
var require_threeDFace = __commonJS({
  "node_modules/dxf/lib/handlers/entity/threeDFace.js"(exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", {
      value: true
    });
    exports.process = exports["default"] = exports.TYPE = void 0;
    var _common = _interopRequireDefault(require_common());
    function _interopRequireDefault(e) {
      return e && e.__esModule ? e : { "default": e };
    }
    var TYPE = exports.TYPE = "3DFACE";
    var process = exports.process = function process2(tuples) {
      return tuples.reduce(function(entity, tuple) {
        var type = tuple[0];
        var value = tuple[1];
        switch (type) {
          case 10:
            entity.vertices[0].x = value;
            break;
          case 20:
            entity.vertices[0].y = value;
            break;
          case 30:
            entity.vertices[0].z = value;
            break;
          case 11:
            entity.vertices[1].x = value;
            break;
          case 21:
            entity.vertices[1].y = value;
            break;
          case 31:
            entity.vertices[1].z = value;
            break;
          case 12:
            entity.vertices[2].x = value;
            break;
          case 22:
            entity.vertices[2].y = value;
            break;
          case 32:
            entity.vertices[2].z = value;
            break;
          case 13:
            entity.vertices[3].x = value;
            break;
          case 23:
            entity.vertices[3].y = value;
            break;
          case 33:
            entity.vertices[3].z = value;
            break;
          default:
            Object.assign(entity, (0, _common["default"])(type, value));
            break;
        }
        return entity;
      }, {
        type: TYPE,
        vertices: [{}, {}, {}, {}]
      });
    };
    var _default = exports["default"] = {
      TYPE,
      process
    };
  }
});

// node_modules/dxf/lib/handlers/entity/dimension.js
var require_dimension = __commonJS({
  "node_modules/dxf/lib/handlers/entity/dimension.js"(exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", {
      value: true
    });
    exports.process = exports["default"] = exports.TYPE = void 0;
    var _common = _interopRequireDefault(require_common());
    function _interopRequireDefault(e) {
      return e && e.__esModule ? e : { "default": e };
    }
    var TYPE = exports.TYPE = "DIMENSION";
    var process = exports.process = function process2(tuples) {
      return tuples.reduce(function(entity, tuple) {
        var type = tuple[0];
        var value = tuple[1];
        switch (type) {
          case 2:
            entity.block = value;
            break;
          case 10:
            entity.start.x = value;
            break;
          case 20:
            entity.start.y = value;
            break;
          case 30:
            entity.start.z = value;
            break;
          case 11:
            entity.textMidpoint.x = value;
            break;
          case 21:
            entity.textMidpoint.y = value;
            break;
          case 31:
            entity.textMidpoint.z = value;
            break;
          case 13:
            entity.measureStart.x = value;
            break;
          case 23:
            entity.measureStart.y = value;
            break;
          case 33:
            entity.measureStart.z = value;
            break;
          case 14:
            entity.measureEnd.x = value;
            break;
          case 24:
            entity.measureEnd.y = value;
            break;
          case 34:
            entity.measureEnd.z = value;
            break;
          case 50:
            entity.rotation = value;
            break;
          case 51:
            entity.horizonRotation = value;
            break;
          case 52:
            entity.extensionRotation = value;
            break;
          case 53:
            entity.textRotation = value;
            break;
          case 70: {
            var dimType = parseBitCombinationsFromValue(value);
            if (dimType.ordinateType) {
              entity.ordinateType = true;
            }
            if (dimType.uniqueBlockReference) {
              entity.uniqueBlockReference = true;
            }
            if (dimType.userDefinedLocation) {
              entity.userDefinedLocation = true;
            }
            entity.dimensionType = dimType.dimensionType;
            break;
          }
          case 71:
            entity.attachementPoint = value;
            break;
          case 210:
            entity.extrudeDirection = entity.extrudeDirection || {};
            entity.extrudeDirection.x = value;
            break;
          case 220:
            entity.extrudeDirection = entity.extrudeDirection || {};
            entity.extrudeDirection.y = value;
            break;
          case 230:
            entity.extrudeDirection = entity.extrudeDirection || {};
            entity.extrudeDirection.z = value;
            break;
          default:
            Object.assign(entity, (0, _common["default"])(type, value));
            break;
        }
        return entity;
      }, {
        type: TYPE,
        start: {
          x: 0,
          y: 0,
          z: 0
        },
        measureStart: {
          x: 0,
          y: 0,
          z: 0
        },
        measureEnd: {
          x: 0,
          y: 0,
          z: 0
        },
        textMidpoint: {
          x: 0,
          y: 0,
          z: 0
        },
        attachementPoint: 1,
        dimensionType: 0
      });
    };
    function parseBitCombinationsFromValue(value) {
      var uniqueBlockReference = false;
      var ordinateType = false;
      var userDefinedLocation = false;
      if (value > 6) {
        var alt1 = value - 32;
        var alt2 = value - 64;
        var alt3 = value - 32 - 64;
        var alt4 = value - 32 - 128;
        var alt5 = value - 32 - 64 - 128;
        if (alt1 >= 0 && alt1 <= 6) {
          uniqueBlockReference = true;
          value = alt1;
        } else if (alt2 >= 0 && alt2 <= 6) {
          ordinateType = true;
          value = alt2;
        } else if (alt3 >= 0 && alt3 <= 6) {
          uniqueBlockReference = true;
          ordinateType = true;
          value = alt3;
        } else if (alt4 >= 0 && alt4 <= 6) {
          uniqueBlockReference = true;
          userDefinedLocation = true;
          value = alt4;
        } else if (alt5 >= 0 && alt5 <= 6) {
          uniqueBlockReference = true;
          ordinateType = true;
          userDefinedLocation = true;
          value = alt5;
        }
      }
      return {
        dimensionType: value,
        uniqueBlockReference,
        ordinateType,
        userDefinedLocation
      };
    }
    var _default = exports["default"] = {
      TYPE,
      process
    };
  }
});

// node_modules/dxf/lib/handlers/entity/viewport.js
var require_viewport = __commonJS({
  "node_modules/dxf/lib/handlers/entity/viewport.js"(exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", {
      value: true
    });
    exports.process = exports["default"] = exports.TYPE = void 0;
    var _common = _interopRequireDefault(require_common());
    function _interopRequireDefault(e) {
      return e && e.__esModule ? e : { "default": e };
    }
    var TYPE = exports.TYPE = "VIEWPORT";
    var process = exports.process = function process2(tuples) {
      return tuples.reduce(function(entity, tuple) {
        var type = tuple[0];
        var value = tuple[1];
        switch (type) {
          case 1:
            entity.layout = parseFloat(value);
            break;
          case 10:
            entity.center.x = parseFloat(value);
            break;
          case 20:
            entity.center.y = parseFloat(value);
            break;
          case 30:
            entity.center.z = parseFloat(value);
            break;
          case 12:
            entity.centerDCS.x = parseFloat(value);
            break;
          case 22:
            entity.centerDCS.y = parseFloat(value);
            break;
          case 13:
            entity.snap.x = parseFloat(value);
            break;
          case 23:
            entity.snap.y = parseFloat(value);
            break;
          case 14:
            entity.snapSpacing.x = parseFloat(value);
            break;
          case 24:
            entity.snapSpacing.y = parseFloat(value);
            break;
          case 15:
            entity.gridSpacing.x = parseFloat(value);
            break;
          case 25:
            entity.gridSpacing.y = parseFloat(value);
            break;
          case 16:
            entity.direction.x = parseFloat(value);
            break;
          case 26:
            entity.direction.y = parseFloat(value);
            break;
          case 36:
            entity.direction.z = parseFloat(value);
            break;
          case 17:
            entity.target.x = parseFloat(value);
            break;
          case 27:
            entity.target.y = parseFloat(value);
            break;
          case 37:
            entity.target.z = parseFloat(value);
            break;
          case 40:
            entity.width = parseFloat(value);
            break;
          case 41:
            entity.height = parseFloat(value);
            break;
          case 50:
            entity.snapAngle = parseFloat(value);
            break;
          case 51:
            entity.angle = parseFloat(value);
            break;
          case 68:
            entity.status = value;
            break;
          case 69:
            entity.id = value;
            break;
          case 90:
            entity.flags = value;
            break;
          case 110:
            entity.x = parseFloat(value);
            break;
          case 120:
            entity.y = parseFloat(value);
            break;
          case 130:
            entity.z = parseFloat(value);
            break;
          case 111:
            entity.xAxisX = parseFloat(value);
            break;
          case 121:
            entity.xAxisY = parseFloat(value);
            break;
          case 131:
            entity.xAxisZ = parseFloat(value);
            break;
          case 112:
            entity.xAxisX = parseFloat(value);
            break;
          case 122:
            entity.xAxisY = parseFloat(value);
            break;
          case 132:
            entity.xAxisZ = parseFloat(value);
            break;
          case 146:
            entity.elevation = parseFloat(value);
            break;
          case 281:
            entity.render = value;
            break;
          default:
            Object.assign(entity, (0, _common["default"])(type, value));
            break;
        }
        return entity;
      }, {
        type: TYPE,
        center: {},
        centerDCS: {},
        snap: {},
        snapSpacing: {},
        gridSpacing: {},
        direction: {},
        target: {}
      });
    };
    var _default = exports["default"] = {
      TYPE,
      process
    };
  }
});

// node_modules/dxf/lib/handlers/entity/ole2Frame.js
var require_ole2Frame = __commonJS({
  "node_modules/dxf/lib/handlers/entity/ole2Frame.js"(exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", {
      value: true
    });
    exports.process = exports["default"] = exports.TYPE = void 0;
    var _common = _interopRequireDefault(require_common());
    function _interopRequireDefault(e) {
      return e && e.__esModule ? e : { "default": e };
    }
    var TYPE = exports.TYPE = "OLE2FRAME";
    var process = exports.process = function process2(tuples) {
      return tuples.reduce(function(entity, tuple) {
        var type = tuple[0];
        var value = tuple[1];
        switch (type) {
          case 70:
            entity.version = value;
            break;
          case 3:
            entity.name = value;
            break;
          case 10:
            entity.upperLeftX = value;
            break;
          case 20:
            entity.upperLeftY = value;
            break;
          case 30:
            entity.upperLeftZ = value;
            break;
          case 11:
            entity.lowerRightX = value;
            break;
          case 21:
            entity.lowerRightY = value;
            break;
          case 31:
            entity.lowerRightZ = value;
            break;
          case 71:
            entity.objectType = value;
            break;
          case 72:
            entity.tile = value;
            break;
          case 90:
            entity.length = value;
            break;
          case 310:
            entity.data += value;
            break;
          default:
            Object.assign(entity, (0, _common["default"])(type, value));
            break;
        }
        return entity;
      }, {
        type: TYPE,
        data: ""
      });
    };
    var _default = exports["default"] = {
      TYPE,
      process
    };
  }
});

// node_modules/dxf/lib/handlers/entities.js
var require_entities = __commonJS({
  "node_modules/dxf/lib/handlers/entities.js"(exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", {
      value: true
    });
    exports["default"] = void 0;
    var _logger = _interopRequireDefault(require_logger());
    var _point = _interopRequireDefault(require_point());
    var _line = _interopRequireDefault(require_line());
    var _lwpolyline = _interopRequireDefault(require_lwpolyline());
    var _polyline = _interopRequireDefault(require_polyline());
    var _vertex = _interopRequireDefault(require_vertex());
    var _circle = _interopRequireDefault(require_circle());
    var _arc = _interopRequireDefault(require_arc());
    var _ellipse = _interopRequireDefault(require_ellipse());
    var _spline = _interopRequireDefault(require_spline());
    var _solid = _interopRequireDefault(require_solid());
    var _hatch = _interopRequireDefault(require_hatch());
    var _mtext = _interopRequireDefault(require_mtext());
    var _attdef = _interopRequireDefault(require_attdef());
    var _attrib = _interopRequireDefault(require_attrib());
    var _insert = _interopRequireDefault(require_insert());
    var _threeDFace = _interopRequireDefault(require_threeDFace());
    var _dimension = _interopRequireDefault(require_dimension());
    var _text = _interopRequireDefault(require_text());
    var _viewport = _interopRequireDefault(require_viewport());
    var _ole2Frame = _interopRequireDefault(require_ole2Frame());
    function _interopRequireDefault(e) {
      return e && e.__esModule ? e : { "default": e };
    }
    var handlers = [_point["default"], _line["default"], _lwpolyline["default"], _polyline["default"], _vertex["default"], _circle["default"], _arc["default"], _ellipse["default"], _spline["default"], _solid["default"], _hatch["default"], _mtext["default"], _attdef["default"], _attrib["default"], _text["default"], _insert["default"], _dimension["default"], _threeDFace["default"], _viewport["default"], _ole2Frame["default"]].reduce(function(acc, mod) {
      acc[mod.TYPE] = mod;
      return acc;
    }, {});
    var _default = exports["default"] = function _default2(tuples) {
      var entities = [];
      var entityGroups = [];
      var currentEntityTuples;
      tuples.forEach(function(tuple) {
        var type = tuple[0];
        if (type === 0) {
          currentEntityTuples = [];
          entityGroups.push(currentEntityTuples);
        }
        currentEntityTuples.push(tuple);
      });
      var currentPolyline;
      entityGroups.forEach(function(tuples2) {
        var entityType = tuples2[0][1];
        var contentTuples = tuples2.slice(1);
        if (handlers[entityType] !== void 0) {
          var e = handlers[entityType].process(contentTuples);
          if (entityType === "POLYLINE") {
            currentPolyline = e;
            entities.push(e);
          } else if (entityType === "VERTEX") {
            if (currentPolyline) {
              currentPolyline.vertices.push(e);
            } else {
              _logger["default"].error("ignoring invalid VERTEX entity");
            }
          } else if (entityType === "SEQEND") {
            currentPolyline = void 0;
          } else {
            entities.push(e);
          }
        } else {
          _logger["default"].warn("unsupported type in ENTITIES section:", entityType);
        }
      });
      return entities;
    };
  }
});

// node_modules/dxf/lib/handlers/blocks.js
var require_blocks = __commonJS({
  "node_modules/dxf/lib/handlers/blocks.js"(exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", {
      value: true
    });
    exports["default"] = void 0;
    var _entities = _interopRequireDefault(require_entities());
    function _interopRequireDefault(e) {
      return e && e.__esModule ? e : { "default": e };
    }
    var _default = exports["default"] = function _default2(tuples) {
      var state;
      var blocks = [];
      var block;
      var entitiesTuples = [];
      tuples.forEach(function(tuple) {
        var type = tuple[0];
        var value = tuple[1];
        if (value === "BLOCK") {
          state = "block";
          block = {};
          entitiesTuples = [];
          blocks.push(block);
        } else if (value === "ENDBLK") {
          if (state === "entities") {
            block.entities = (0, _entities["default"])(entitiesTuples);
          } else {
            block.entities = [];
          }
          entitiesTuples = void 0;
          state = void 0;
        } else if (state === "block" && type !== 0) {
          switch (type) {
            case 1:
              block.xref = value;
              break;
            case 2:
              block.name = value;
              break;
            case 10:
              block.x = value;
              break;
            case 20:
              block.y = value;
              break;
            case 30:
              block.z = value;
              break;
            case 67:
              {
                if (value !== 0) block.paperSpace = value;
              }
              break;
            case 410:
              block.layout = value;
              break;
            default:
              break;
          }
        } else if (state === "block" && type === 0) {
          state = "entities";
          entitiesTuples.push(tuple);
        } else if (state === "entities") {
          entitiesTuples.push(tuple);
        }
      });
      return blocks;
    };
  }
});

// node_modules/dxf/lib/handlers/objects.js
var require_objects = __commonJS({
  "node_modules/dxf/lib/handlers/objects.js"(exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", {
      value: true
    });
    exports["default"] = void 0;
    var _default = exports["default"] = function _default2(tuples) {
      var state;
      var objects = {
        layouts: []
      };
      var layout = {};
      tuples.forEach(function(tuple, i) {
        var type = tuple[0];
        var value = tuple[1];
        if (type === 0) {
          state = "IDLE";
        }
        if (value === "LAYOUT") {
          state = "layout";
          layout = {};
          objects.layouts.push(layout);
        }
        if (state === "layout" && type !== 0) {
          switch (type) {
            case 100:
              {
                if (value === "AcDbLayout") state = "AcDbLayout";
              }
              break;
          }
        }
        if (state === "AcDbLayout" && type !== 0) {
          switch (type) {
            case 1:
              {
                layout.name = value;
              }
              break;
            case 5:
              {
                layout.handle = value;
              }
              break;
            case 10:
              {
                layout.minLimitX = parseFloat(value);
              }
              break;
            case 20:
              {
                layout.minLimitY = parseFloat(value);
              }
              break;
            case 11:
              {
                layout.maxLimitX = parseFloat(value);
              }
              break;
            case 21:
              {
                layout.maxLimitY = parseFloat(value);
              }
              break;
            case 12:
              {
                layout.x = parseFloat(value);
              }
              break;
            case 22:
              {
                layout.y = parseFloat(value);
              }
              break;
            case 32:
              {
                layout.z = parseFloat(value);
              }
              break;
            case 14:
              {
                layout.minX = parseFloat(value);
              }
              break;
            case 24:
              {
                layout.minY = parseFloat(value);
              }
              break;
            case 34:
              {
                layout.minZ = parseFloat(value);
              }
              break;
            case 15:
              {
                layout.maxX = parseFloat(value);
              }
              break;
            case 25:
              {
                layout.maxY = parseFloat(value);
              }
              break;
            case 35:
              {
                layout.maxZ = parseFloat(value);
              }
              break;
            case 70:
              {
                layout.flag = value === 1 ? "PSLTSCALE" : "LIMCHECK";
              }
              break;
            case 71:
              {
                layout.tabOrder = value;
              }
              break;
            case 146:
              {
                layout.elevation = parseFloat(value);
              }
              break;
            case 13:
              {
                layout.ucsX = parseFloat(value);
              }
              break;
            case 23:
              {
                layout.ucsY = parseFloat(value);
              }
              break;
            case 33:
              {
                layout.ucsZ = parseFloat(value);
              }
              break;
            case 16:
              {
                layout.ucsXaxisX = parseFloat(value);
              }
              break;
            case 26:
              {
                layout.ucsXaxisY = parseFloat(value);
              }
              break;
            case 36:
              {
                layout.ucsXaxisZ = parseFloat(value);
              }
              break;
            case 17:
              {
                layout.ucsYaxisX = parseFloat(value);
              }
              break;
            case 27:
              {
                layout.ucsYaxisY = parseFloat(value);
              }
              break;
            case 37:
              {
                layout.ucsYaxisZ = parseFloat(value);
              }
              break;
            case 76:
              {
                switch (value) {
                  case 0:
                    {
                      layout.ucsType = "NOT ORTHOGRAPHIC";
                    }
                    break;
                  case 1:
                    {
                      layout.ucsType = "TOP";
                    }
                    break;
                  case 2:
                    {
                      layout.ucsType = "BOTTOM";
                    }
                    break;
                  case 3:
                    {
                      layout.ucsType = "FRONT";
                    }
                    break;
                  case 4:
                    {
                      layout.ucsType = "BACK";
                    }
                    break;
                  case 5:
                    {
                      layout.ucsType = "LEFT";
                    }
                    break;
                  case 6:
                    {
                      layout.ucsType = "RIGHT";
                    }
                    break;
                }
              }
              break;
            case 330:
              {
                layout.tableRecord = value;
              }
              break;
            case 331:
              {
                layout.lastActiveViewport = value;
              }
              break;
            case 333:
              {
                layout.shadePlot = value;
              }
              break;
          }
        }
      });
      return objects;
    };
  }
});

// node_modules/dxf/lib/parseString.js
var require_parseString = __commonJS({
  "node_modules/dxf/lib/parseString.js"(exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", {
      value: true
    });
    exports["default"] = void 0;
    var _header = _interopRequireDefault(require_header());
    var _tables = _interopRequireDefault(require_tables());
    var _blocks = _interopRequireDefault(require_blocks());
    var _entities = _interopRequireDefault(require_entities());
    var _objects = _interopRequireDefault(require_objects());
    var _logger = _interopRequireDefault(require_logger());
    function _interopRequireDefault(e) {
      return e && e.__esModule ? e : { "default": e };
    }
    function _createForOfIteratorHelper(r, e) {
      var t = "undefined" != typeof Symbol && r[Symbol.iterator] || r["@@iterator"];
      if (!t) {
        if (Array.isArray(r) || (t = _unsupportedIterableToArray(r)) || e && r && "number" == typeof r.length) {
          t && (r = t);
          var _n = 0, F = function F2() {
          };
          return { s: F, n: function n() {
            return _n >= r.length ? { done: true } : { done: false, value: r[_n++] };
          }, e: function e2(r2) {
            throw r2;
          }, f: F };
        }
        throw new TypeError("Invalid attempt to iterate non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method.");
      }
      var o, a = true, u = false;
      return { s: function s() {
        t = t.call(r);
      }, n: function n() {
        var r2 = t.next();
        return a = r2.done, r2;
      }, e: function e2(r2) {
        u = true, o = r2;
      }, f: function f() {
        try {
          a || null == t["return"] || t["return"]();
        } finally {
          if (u) throw o;
        }
      } };
    }
    function _unsupportedIterableToArray(r, a) {
      if (r) {
        if ("string" == typeof r) return _arrayLikeToArray(r, a);
        var t = {}.toString.call(r).slice(8, -1);
        return "Object" === t && r.constructor && (t = r.constructor.name), "Map" === t || "Set" === t ? Array.from(r) : "Arguments" === t || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(t) ? _arrayLikeToArray(r, a) : void 0;
      }
    }
    function _arrayLikeToArray(r, a) {
      (null == a || a > r.length) && (a = r.length);
      for (var e = 0, n = Array(a); e < a; e++) n[e] = r[e];
      return n;
    }
    var parseValue = function parseValue2(type, value) {
      if (type >= 10 && type < 60) {
        return parseFloat(value, 10);
      } else if (type >= 210 && type < 240) {
        return parseFloat(value, 10);
      } else if (type >= 60 && type < 100) {
        return parseInt(value, 10);
      } else {
        return value;
      }
    };
    var convertToTypesAndValues = function convertToTypesAndValues2(contentLines) {
      var state = "type";
      var type;
      var typesAndValues = [];
      var _iterator = _createForOfIteratorHelper(contentLines), _step;
      try {
        for (_iterator.s(); !(_step = _iterator.n()).done; ) {
          var line = _step.value;
          if (state === "type") {
            type = parseInt(line, 10);
            state = "value";
          } else {
            typesAndValues.push([type, parseValue(type, line)]);
            state = "type";
          }
        }
      } catch (err) {
        _iterator.e(err);
      } finally {
        _iterator.f();
      }
      return typesAndValues;
    };
    var separateSections = function separateSections2(tuples) {
      var sectionTuples;
      return tuples.reduce(function(sections, tuple) {
        if (tuple[0] === 0 && tuple[1] === "SECTION") {
          sectionTuples = [];
        } else if (tuple[0] === 0 && tuple[1] === "ENDSEC") {
          sections.push(sectionTuples);
          sectionTuples = void 0;
        } else if (sectionTuples !== void 0) {
          sectionTuples.push(tuple);
        }
        return sections;
      }, []);
    };
    var reduceSection = function reduceSection2(acc, section) {
      var sectionType = section[0][1];
      var contentTuples = section.slice(1);
      switch (sectionType) {
        case "HEADER":
          acc.header = (0, _header["default"])(contentTuples);
          break;
        case "TABLES":
          acc.tables = (0, _tables["default"])(contentTuples);
          break;
        case "BLOCKS":
          acc.blocks = (0, _blocks["default"])(contentTuples);
          break;
        case "ENTITIES":
          acc.entities = (0, _entities["default"])(contentTuples);
          break;
        case "OBJECTS":
          acc.objects = (0, _objects["default"])(contentTuples);
          break;
        default:
          _logger["default"].warn("Unsupported section: ".concat(sectionType));
      }
      return acc;
    };
    var _default = exports["default"] = function _default2(string) {
      var lines = string.split(/\r\n|\r|\n/g);
      var tuples = convertToTypesAndValues(lines);
      var sections = separateSections(tuples);
      var result = sections.reduce(reduceSection, {
        // Start with empty defaults in the event of empty sections
        header: {},
        blocks: [],
        entities: [],
        objects: {
          layouts: []
        },
        tables: {
          layers: {},
          styles: {},
          ltypes: {}
        }
      });
      return result;
    };
  }
});

// node_modules/lodash/_listCacheClear.js
var require_listCacheClear = __commonJS({
  "node_modules/lodash/_listCacheClear.js"(exports, module) {
    function listCacheClear() {
      this.__data__ = [];
      this.size = 0;
    }
    module.exports = listCacheClear;
  }
});

// node_modules/lodash/eq.js
var require_eq = __commonJS({
  "node_modules/lodash/eq.js"(exports, module) {
    function eq(value, other) {
      return value === other || value !== value && other !== other;
    }
    module.exports = eq;
  }
});

// node_modules/lodash/_assocIndexOf.js
var require_assocIndexOf = __commonJS({
  "node_modules/lodash/_assocIndexOf.js"(exports, module) {
    var eq = require_eq();
    function assocIndexOf(array, key) {
      var length = array.length;
      while (length--) {
        if (eq(array[length][0], key)) {
          return length;
        }
      }
      return -1;
    }
    module.exports = assocIndexOf;
  }
});

// node_modules/lodash/_listCacheDelete.js
var require_listCacheDelete = __commonJS({
  "node_modules/lodash/_listCacheDelete.js"(exports, module) {
    var assocIndexOf = require_assocIndexOf();
    var arrayProto = Array.prototype;
    var splice = arrayProto.splice;
    function listCacheDelete(key) {
      var data = this.__data__, index = assocIndexOf(data, key);
      if (index < 0) {
        return false;
      }
      var lastIndex = data.length - 1;
      if (index == lastIndex) {
        data.pop();
      } else {
        splice.call(data, index, 1);
      }
      --this.size;
      return true;
    }
    module.exports = listCacheDelete;
  }
});

// node_modules/lodash/_listCacheGet.js
var require_listCacheGet = __commonJS({
  "node_modules/lodash/_listCacheGet.js"(exports, module) {
    var assocIndexOf = require_assocIndexOf();
    function listCacheGet(key) {
      var data = this.__data__, index = assocIndexOf(data, key);
      return index < 0 ? void 0 : data[index][1];
    }
    module.exports = listCacheGet;
  }
});

// node_modules/lodash/_listCacheHas.js
var require_listCacheHas = __commonJS({
  "node_modules/lodash/_listCacheHas.js"(exports, module) {
    var assocIndexOf = require_assocIndexOf();
    function listCacheHas(key) {
      return assocIndexOf(this.__data__, key) > -1;
    }
    module.exports = listCacheHas;
  }
});

// node_modules/lodash/_listCacheSet.js
var require_listCacheSet = __commonJS({
  "node_modules/lodash/_listCacheSet.js"(exports, module) {
    var assocIndexOf = require_assocIndexOf();
    function listCacheSet(key, value) {
      var data = this.__data__, index = assocIndexOf(data, key);
      if (index < 0) {
        ++this.size;
        data.push([key, value]);
      } else {
        data[index][1] = value;
      }
      return this;
    }
    module.exports = listCacheSet;
  }
});

// node_modules/lodash/_ListCache.js
var require_ListCache = __commonJS({
  "node_modules/lodash/_ListCache.js"(exports, module) {
    var listCacheClear = require_listCacheClear();
    var listCacheDelete = require_listCacheDelete();
    var listCacheGet = require_listCacheGet();
    var listCacheHas = require_listCacheHas();
    var listCacheSet = require_listCacheSet();
    function ListCache(entries) {
      var index = -1, length = entries == null ? 0 : entries.length;
      this.clear();
      while (++index < length) {
        var entry = entries[index];
        this.set(entry[0], entry[1]);
      }
    }
    ListCache.prototype.clear = listCacheClear;
    ListCache.prototype["delete"] = listCacheDelete;
    ListCache.prototype.get = listCacheGet;
    ListCache.prototype.has = listCacheHas;
    ListCache.prototype.set = listCacheSet;
    module.exports = ListCache;
  }
});

// node_modules/lodash/_stackClear.js
var require_stackClear = __commonJS({
  "node_modules/lodash/_stackClear.js"(exports, module) {
    var ListCache = require_ListCache();
    function stackClear() {
      this.__data__ = new ListCache();
      this.size = 0;
    }
    module.exports = stackClear;
  }
});

// node_modules/lodash/_stackDelete.js
var require_stackDelete = __commonJS({
  "node_modules/lodash/_stackDelete.js"(exports, module) {
    function stackDelete(key) {
      var data = this.__data__, result = data["delete"](key);
      this.size = data.size;
      return result;
    }
    module.exports = stackDelete;
  }
});

// node_modules/lodash/_stackGet.js
var require_stackGet = __commonJS({
  "node_modules/lodash/_stackGet.js"(exports, module) {
    function stackGet(key) {
      return this.__data__.get(key);
    }
    module.exports = stackGet;
  }
});

// node_modules/lodash/_stackHas.js
var require_stackHas = __commonJS({
  "node_modules/lodash/_stackHas.js"(exports, module) {
    function stackHas(key) {
      return this.__data__.has(key);
    }
    module.exports = stackHas;
  }
});

// node_modules/lodash/_freeGlobal.js
var require_freeGlobal = __commonJS({
  "node_modules/lodash/_freeGlobal.js"(exports, module) {
    var freeGlobal = typeof global == "object" && global && global.Object === Object && global;
    module.exports = freeGlobal;
  }
});

// node_modules/lodash/_root.js
var require_root = __commonJS({
  "node_modules/lodash/_root.js"(exports, module) {
    var freeGlobal = require_freeGlobal();
    var freeSelf = typeof self == "object" && self && self.Object === Object && self;
    var root = freeGlobal || freeSelf || Function("return this")();
    module.exports = root;
  }
});

// node_modules/lodash/_Symbol.js
var require_Symbol = __commonJS({
  "node_modules/lodash/_Symbol.js"(exports, module) {
    var root = require_root();
    var Symbol2 = root.Symbol;
    module.exports = Symbol2;
  }
});

// node_modules/lodash/_getRawTag.js
var require_getRawTag = __commonJS({
  "node_modules/lodash/_getRawTag.js"(exports, module) {
    var Symbol2 = require_Symbol();
    var objectProto = Object.prototype;
    var hasOwnProperty = objectProto.hasOwnProperty;
    var nativeObjectToString = objectProto.toString;
    var symToStringTag = Symbol2 ? Symbol2.toStringTag : void 0;
    function getRawTag(value) {
      var isOwn = hasOwnProperty.call(value, symToStringTag), tag = value[symToStringTag];
      try {
        value[symToStringTag] = void 0;
        var unmasked = true;
      } catch (e) {
      }
      var result = nativeObjectToString.call(value);
      if (unmasked) {
        if (isOwn) {
          value[symToStringTag] = tag;
        } else {
          delete value[symToStringTag];
        }
      }
      return result;
    }
    module.exports = getRawTag;
  }
});

// node_modules/lodash/_objectToString.js
var require_objectToString = __commonJS({
  "node_modules/lodash/_objectToString.js"(exports, module) {
    var objectProto = Object.prototype;
    var nativeObjectToString = objectProto.toString;
    function objectToString(value) {
      return nativeObjectToString.call(value);
    }
    module.exports = objectToString;
  }
});

// node_modules/lodash/_baseGetTag.js
var require_baseGetTag = __commonJS({
  "node_modules/lodash/_baseGetTag.js"(exports, module) {
    var Symbol2 = require_Symbol();
    var getRawTag = require_getRawTag();
    var objectToString = require_objectToString();
    var nullTag = "[object Null]";
    var undefinedTag = "[object Undefined]";
    var symToStringTag = Symbol2 ? Symbol2.toStringTag : void 0;
    function baseGetTag(value) {
      if (value == null) {
        return value === void 0 ? undefinedTag : nullTag;
      }
      return symToStringTag && symToStringTag in Object(value) ? getRawTag(value) : objectToString(value);
    }
    module.exports = baseGetTag;
  }
});

// node_modules/lodash/isObject.js
var require_isObject = __commonJS({
  "node_modules/lodash/isObject.js"(exports, module) {
    function isObject(value) {
      var type = typeof value;
      return value != null && (type == "object" || type == "function");
    }
    module.exports = isObject;
  }
});

// node_modules/lodash/isFunction.js
var require_isFunction = __commonJS({
  "node_modules/lodash/isFunction.js"(exports, module) {
    var baseGetTag = require_baseGetTag();
    var isObject = require_isObject();
    var asyncTag = "[object AsyncFunction]";
    var funcTag = "[object Function]";
    var genTag = "[object GeneratorFunction]";
    var proxyTag = "[object Proxy]";
    function isFunction(value) {
      if (!isObject(value)) {
        return false;
      }
      var tag = baseGetTag(value);
      return tag == funcTag || tag == genTag || tag == asyncTag || tag == proxyTag;
    }
    module.exports = isFunction;
  }
});

// node_modules/lodash/_coreJsData.js
var require_coreJsData = __commonJS({
  "node_modules/lodash/_coreJsData.js"(exports, module) {
    var root = require_root();
    var coreJsData = root["__core-js_shared__"];
    module.exports = coreJsData;
  }
});

// node_modules/lodash/_isMasked.js
var require_isMasked = __commonJS({
  "node_modules/lodash/_isMasked.js"(exports, module) {
    var coreJsData = require_coreJsData();
    var maskSrcKey = (function() {
      var uid = /[^.]+$/.exec(coreJsData && coreJsData.keys && coreJsData.keys.IE_PROTO || "");
      return uid ? "Symbol(src)_1." + uid : "";
    })();
    function isMasked(func) {
      return !!maskSrcKey && maskSrcKey in func;
    }
    module.exports = isMasked;
  }
});

// node_modules/lodash/_toSource.js
var require_toSource = __commonJS({
  "node_modules/lodash/_toSource.js"(exports, module) {
    var funcProto = Function.prototype;
    var funcToString = funcProto.toString;
    function toSource(func) {
      if (func != null) {
        try {
          return funcToString.call(func);
        } catch (e) {
        }
        try {
          return func + "";
        } catch (e) {
        }
      }
      return "";
    }
    module.exports = toSource;
  }
});

// node_modules/lodash/_baseIsNative.js
var require_baseIsNative = __commonJS({
  "node_modules/lodash/_baseIsNative.js"(exports, module) {
    var isFunction = require_isFunction();
    var isMasked = require_isMasked();
    var isObject = require_isObject();
    var toSource = require_toSource();
    var reRegExpChar = /[\\^$.*+?()[\]{}|]/g;
    var reIsHostCtor = /^\[object .+?Constructor\]$/;
    var funcProto = Function.prototype;
    var objectProto = Object.prototype;
    var funcToString = funcProto.toString;
    var hasOwnProperty = objectProto.hasOwnProperty;
    var reIsNative = RegExp(
      "^" + funcToString.call(hasOwnProperty).replace(reRegExpChar, "\\$&").replace(/hasOwnProperty|(function).*?(?=\\\()| for .+?(?=\\\])/g, "$1.*?") + "$"
    );
    function baseIsNative(value) {
      if (!isObject(value) || isMasked(value)) {
        return false;
      }
      var pattern = isFunction(value) ? reIsNative : reIsHostCtor;
      return pattern.test(toSource(value));
    }
    module.exports = baseIsNative;
  }
});

// node_modules/lodash/_getValue.js
var require_getValue = __commonJS({
  "node_modules/lodash/_getValue.js"(exports, module) {
    function getValue(object, key) {
      return object == null ? void 0 : object[key];
    }
    module.exports = getValue;
  }
});

// node_modules/lodash/_getNative.js
var require_getNative = __commonJS({
  "node_modules/lodash/_getNative.js"(exports, module) {
    var baseIsNative = require_baseIsNative();
    var getValue = require_getValue();
    function getNative(object, key) {
      var value = getValue(object, key);
      return baseIsNative(value) ? value : void 0;
    }
    module.exports = getNative;
  }
});

// node_modules/lodash/_Map.js
var require_Map = __commonJS({
  "node_modules/lodash/_Map.js"(exports, module) {
    var getNative = require_getNative();
    var root = require_root();
    var Map = getNative(root, "Map");
    module.exports = Map;
  }
});

// node_modules/lodash/_nativeCreate.js
var require_nativeCreate = __commonJS({
  "node_modules/lodash/_nativeCreate.js"(exports, module) {
    var getNative = require_getNative();
    var nativeCreate = getNative(Object, "create");
    module.exports = nativeCreate;
  }
});

// node_modules/lodash/_hashClear.js
var require_hashClear = __commonJS({
  "node_modules/lodash/_hashClear.js"(exports, module) {
    var nativeCreate = require_nativeCreate();
    function hashClear() {
      this.__data__ = nativeCreate ? nativeCreate(null) : {};
      this.size = 0;
    }
    module.exports = hashClear;
  }
});

// node_modules/lodash/_hashDelete.js
var require_hashDelete = __commonJS({
  "node_modules/lodash/_hashDelete.js"(exports, module) {
    function hashDelete(key) {
      var result = this.has(key) && delete this.__data__[key];
      this.size -= result ? 1 : 0;
      return result;
    }
    module.exports = hashDelete;
  }
});

// node_modules/lodash/_hashGet.js
var require_hashGet = __commonJS({
  "node_modules/lodash/_hashGet.js"(exports, module) {
    var nativeCreate = require_nativeCreate();
    var HASH_UNDEFINED = "__lodash_hash_undefined__";
    var objectProto = Object.prototype;
    var hasOwnProperty = objectProto.hasOwnProperty;
    function hashGet(key) {
      var data = this.__data__;
      if (nativeCreate) {
        var result = data[key];
        return result === HASH_UNDEFINED ? void 0 : result;
      }
      return hasOwnProperty.call(data, key) ? data[key] : void 0;
    }
    module.exports = hashGet;
  }
});

// node_modules/lodash/_hashHas.js
var require_hashHas = __commonJS({
  "node_modules/lodash/_hashHas.js"(exports, module) {
    var nativeCreate = require_nativeCreate();
    var objectProto = Object.prototype;
    var hasOwnProperty = objectProto.hasOwnProperty;
    function hashHas(key) {
      var data = this.__data__;
      return nativeCreate ? data[key] !== void 0 : hasOwnProperty.call(data, key);
    }
    module.exports = hashHas;
  }
});

// node_modules/lodash/_hashSet.js
var require_hashSet = __commonJS({
  "node_modules/lodash/_hashSet.js"(exports, module) {
    var nativeCreate = require_nativeCreate();
    var HASH_UNDEFINED = "__lodash_hash_undefined__";
    function hashSet(key, value) {
      var data = this.__data__;
      this.size += this.has(key) ? 0 : 1;
      data[key] = nativeCreate && value === void 0 ? HASH_UNDEFINED : value;
      return this;
    }
    module.exports = hashSet;
  }
});

// node_modules/lodash/_Hash.js
var require_Hash = __commonJS({
  "node_modules/lodash/_Hash.js"(exports, module) {
    var hashClear = require_hashClear();
    var hashDelete = require_hashDelete();
    var hashGet = require_hashGet();
    var hashHas = require_hashHas();
    var hashSet = require_hashSet();
    function Hash(entries) {
      var index = -1, length = entries == null ? 0 : entries.length;
      this.clear();
      while (++index < length) {
        var entry = entries[index];
        this.set(entry[0], entry[1]);
      }
    }
    Hash.prototype.clear = hashClear;
    Hash.prototype["delete"] = hashDelete;
    Hash.prototype.get = hashGet;
    Hash.prototype.has = hashHas;
    Hash.prototype.set = hashSet;
    module.exports = Hash;
  }
});

// node_modules/lodash/_mapCacheClear.js
var require_mapCacheClear = __commonJS({
  "node_modules/lodash/_mapCacheClear.js"(exports, module) {
    var Hash = require_Hash();
    var ListCache = require_ListCache();
    var Map = require_Map();
    function mapCacheClear() {
      this.size = 0;
      this.__data__ = {
        "hash": new Hash(),
        "map": new (Map || ListCache)(),
        "string": new Hash()
      };
    }
    module.exports = mapCacheClear;
  }
});

// node_modules/lodash/_isKeyable.js
var require_isKeyable = __commonJS({
  "node_modules/lodash/_isKeyable.js"(exports, module) {
    function isKeyable(value) {
      var type = typeof value;
      return type == "string" || type == "number" || type == "symbol" || type == "boolean" ? value !== "__proto__" : value === null;
    }
    module.exports = isKeyable;
  }
});

// node_modules/lodash/_getMapData.js
var require_getMapData = __commonJS({
  "node_modules/lodash/_getMapData.js"(exports, module) {
    var isKeyable = require_isKeyable();
    function getMapData(map, key) {
      var data = map.__data__;
      return isKeyable(key) ? data[typeof key == "string" ? "string" : "hash"] : data.map;
    }
    module.exports = getMapData;
  }
});

// node_modules/lodash/_mapCacheDelete.js
var require_mapCacheDelete = __commonJS({
  "node_modules/lodash/_mapCacheDelete.js"(exports, module) {
    var getMapData = require_getMapData();
    function mapCacheDelete(key) {
      var result = getMapData(this, key)["delete"](key);
      this.size -= result ? 1 : 0;
      return result;
    }
    module.exports = mapCacheDelete;
  }
});

// node_modules/lodash/_mapCacheGet.js
var require_mapCacheGet = __commonJS({
  "node_modules/lodash/_mapCacheGet.js"(exports, module) {
    var getMapData = require_getMapData();
    function mapCacheGet(key) {
      return getMapData(this, key).get(key);
    }
    module.exports = mapCacheGet;
  }
});

// node_modules/lodash/_mapCacheHas.js
var require_mapCacheHas = __commonJS({
  "node_modules/lodash/_mapCacheHas.js"(exports, module) {
    var getMapData = require_getMapData();
    function mapCacheHas(key) {
      return getMapData(this, key).has(key);
    }
    module.exports = mapCacheHas;
  }
});

// node_modules/lodash/_mapCacheSet.js
var require_mapCacheSet = __commonJS({
  "node_modules/lodash/_mapCacheSet.js"(exports, module) {
    var getMapData = require_getMapData();
    function mapCacheSet(key, value) {
      var data = getMapData(this, key), size = data.size;
      data.set(key, value);
      this.size += data.size == size ? 0 : 1;
      return this;
    }
    module.exports = mapCacheSet;
  }
});

// node_modules/lodash/_MapCache.js
var require_MapCache = __commonJS({
  "node_modules/lodash/_MapCache.js"(exports, module) {
    var mapCacheClear = require_mapCacheClear();
    var mapCacheDelete = require_mapCacheDelete();
    var mapCacheGet = require_mapCacheGet();
    var mapCacheHas = require_mapCacheHas();
    var mapCacheSet = require_mapCacheSet();
    function MapCache(entries) {
      var index = -1, length = entries == null ? 0 : entries.length;
      this.clear();
      while (++index < length) {
        var entry = entries[index];
        this.set(entry[0], entry[1]);
      }
    }
    MapCache.prototype.clear = mapCacheClear;
    MapCache.prototype["delete"] = mapCacheDelete;
    MapCache.prototype.get = mapCacheGet;
    MapCache.prototype.has = mapCacheHas;
    MapCache.prototype.set = mapCacheSet;
    module.exports = MapCache;
  }
});

// node_modules/lodash/_stackSet.js
var require_stackSet = __commonJS({
  "node_modules/lodash/_stackSet.js"(exports, module) {
    var ListCache = require_ListCache();
    var Map = require_Map();
    var MapCache = require_MapCache();
    var LARGE_ARRAY_SIZE = 200;
    function stackSet(key, value) {
      var data = this.__data__;
      if (data instanceof ListCache) {
        var pairs = data.__data__;
        if (!Map || pairs.length < LARGE_ARRAY_SIZE - 1) {
          pairs.push([key, value]);
          this.size = ++data.size;
          return this;
        }
        data = this.__data__ = new MapCache(pairs);
      }
      data.set(key, value);
      this.size = data.size;
      return this;
    }
    module.exports = stackSet;
  }
});

// node_modules/lodash/_Stack.js
var require_Stack = __commonJS({
  "node_modules/lodash/_Stack.js"(exports, module) {
    var ListCache = require_ListCache();
    var stackClear = require_stackClear();
    var stackDelete = require_stackDelete();
    var stackGet = require_stackGet();
    var stackHas = require_stackHas();
    var stackSet = require_stackSet();
    function Stack(entries) {
      var data = this.__data__ = new ListCache(entries);
      this.size = data.size;
    }
    Stack.prototype.clear = stackClear;
    Stack.prototype["delete"] = stackDelete;
    Stack.prototype.get = stackGet;
    Stack.prototype.has = stackHas;
    Stack.prototype.set = stackSet;
    module.exports = Stack;
  }
});

// node_modules/lodash/_arrayEach.js
var require_arrayEach = __commonJS({
  "node_modules/lodash/_arrayEach.js"(exports, module) {
    function arrayEach(array, iteratee) {
      var index = -1, length = array == null ? 0 : array.length;
      while (++index < length) {
        if (iteratee(array[index], index, array) === false) {
          break;
        }
      }
      return array;
    }
    module.exports = arrayEach;
  }
});

// node_modules/lodash/_defineProperty.js
var require_defineProperty = __commonJS({
  "node_modules/lodash/_defineProperty.js"(exports, module) {
    var getNative = require_getNative();
    var defineProperty = (function() {
      try {
        var func = getNative(Object, "defineProperty");
        func({}, "", {});
        return func;
      } catch (e) {
      }
    })();
    module.exports = defineProperty;
  }
});

// node_modules/lodash/_baseAssignValue.js
var require_baseAssignValue = __commonJS({
  "node_modules/lodash/_baseAssignValue.js"(exports, module) {
    var defineProperty = require_defineProperty();
    function baseAssignValue(object, key, value) {
      if (key == "__proto__" && defineProperty) {
        defineProperty(object, key, {
          "configurable": true,
          "enumerable": true,
          "value": value,
          "writable": true
        });
      } else {
        object[key] = value;
      }
    }
    module.exports = baseAssignValue;
  }
});

// node_modules/lodash/_assignValue.js
var require_assignValue = __commonJS({
  "node_modules/lodash/_assignValue.js"(exports, module) {
    var baseAssignValue = require_baseAssignValue();
    var eq = require_eq();
    var objectProto = Object.prototype;
    var hasOwnProperty = objectProto.hasOwnProperty;
    function assignValue(object, key, value) {
      var objValue = object[key];
      if (!(hasOwnProperty.call(object, key) && eq(objValue, value)) || value === void 0 && !(key in object)) {
        baseAssignValue(object, key, value);
      }
    }
    module.exports = assignValue;
  }
});

// node_modules/lodash/_copyObject.js
var require_copyObject = __commonJS({
  "node_modules/lodash/_copyObject.js"(exports, module) {
    var assignValue = require_assignValue();
    var baseAssignValue = require_baseAssignValue();
    function copyObject(source, props, object, customizer) {
      var isNew = !object;
      object || (object = {});
      var index = -1, length = props.length;
      while (++index < length) {
        var key = props[index];
        var newValue = customizer ? customizer(object[key], source[key], key, object, source) : void 0;
        if (newValue === void 0) {
          newValue = source[key];
        }
        if (isNew) {
          baseAssignValue(object, key, newValue);
        } else {
          assignValue(object, key, newValue);
        }
      }
      return object;
    }
    module.exports = copyObject;
  }
});

// node_modules/lodash/_baseTimes.js
var require_baseTimes = __commonJS({
  "node_modules/lodash/_baseTimes.js"(exports, module) {
    function baseTimes(n, iteratee) {
      var index = -1, result = Array(n);
      while (++index < n) {
        result[index] = iteratee(index);
      }
      return result;
    }
    module.exports = baseTimes;
  }
});

// node_modules/lodash/isObjectLike.js
var require_isObjectLike = __commonJS({
  "node_modules/lodash/isObjectLike.js"(exports, module) {
    function isObjectLike(value) {
      return value != null && typeof value == "object";
    }
    module.exports = isObjectLike;
  }
});

// node_modules/lodash/_baseIsArguments.js
var require_baseIsArguments = __commonJS({
  "node_modules/lodash/_baseIsArguments.js"(exports, module) {
    var baseGetTag = require_baseGetTag();
    var isObjectLike = require_isObjectLike();
    var argsTag = "[object Arguments]";
    function baseIsArguments(value) {
      return isObjectLike(value) && baseGetTag(value) == argsTag;
    }
    module.exports = baseIsArguments;
  }
});

// node_modules/lodash/isArguments.js
var require_isArguments = __commonJS({
  "node_modules/lodash/isArguments.js"(exports, module) {
    var baseIsArguments = require_baseIsArguments();
    var isObjectLike = require_isObjectLike();
    var objectProto = Object.prototype;
    var hasOwnProperty = objectProto.hasOwnProperty;
    var propertyIsEnumerable = objectProto.propertyIsEnumerable;
    var isArguments = baseIsArguments(/* @__PURE__ */ (function() {
      return arguments;
    })()) ? baseIsArguments : function(value) {
      return isObjectLike(value) && hasOwnProperty.call(value, "callee") && !propertyIsEnumerable.call(value, "callee");
    };
    module.exports = isArguments;
  }
});

// node_modules/lodash/isArray.js
var require_isArray = __commonJS({
  "node_modules/lodash/isArray.js"(exports, module) {
    var isArray = Array.isArray;
    module.exports = isArray;
  }
});

// node_modules/lodash/stubFalse.js
var require_stubFalse = __commonJS({
  "node_modules/lodash/stubFalse.js"(exports, module) {
    function stubFalse() {
      return false;
    }
    module.exports = stubFalse;
  }
});

// node_modules/lodash/isBuffer.js
var require_isBuffer = __commonJS({
  "node_modules/lodash/isBuffer.js"(exports, module) {
    var root = require_root();
    var stubFalse = require_stubFalse();
    var freeExports = typeof exports == "object" && exports && !exports.nodeType && exports;
    var freeModule = freeExports && typeof module == "object" && module && !module.nodeType && module;
    var moduleExports = freeModule && freeModule.exports === freeExports;
    var Buffer2 = moduleExports ? root.Buffer : void 0;
    var nativeIsBuffer = Buffer2 ? Buffer2.isBuffer : void 0;
    var isBuffer = nativeIsBuffer || stubFalse;
    module.exports = isBuffer;
  }
});

// node_modules/lodash/_isIndex.js
var require_isIndex = __commonJS({
  "node_modules/lodash/_isIndex.js"(exports, module) {
    var MAX_SAFE_INTEGER = 9007199254740991;
    var reIsUint = /^(?:0|[1-9]\d*)$/;
    function isIndex(value, length) {
      var type = typeof value;
      length = length == null ? MAX_SAFE_INTEGER : length;
      return !!length && (type == "number" || type != "symbol" && reIsUint.test(value)) && (value > -1 && value % 1 == 0 && value < length);
    }
    module.exports = isIndex;
  }
});

// node_modules/lodash/isLength.js
var require_isLength = __commonJS({
  "node_modules/lodash/isLength.js"(exports, module) {
    var MAX_SAFE_INTEGER = 9007199254740991;
    function isLength(value) {
      return typeof value == "number" && value > -1 && value % 1 == 0 && value <= MAX_SAFE_INTEGER;
    }
    module.exports = isLength;
  }
});

// node_modules/lodash/_baseIsTypedArray.js
var require_baseIsTypedArray = __commonJS({
  "node_modules/lodash/_baseIsTypedArray.js"(exports, module) {
    var baseGetTag = require_baseGetTag();
    var isLength = require_isLength();
    var isObjectLike = require_isObjectLike();
    var argsTag = "[object Arguments]";
    var arrayTag = "[object Array]";
    var boolTag = "[object Boolean]";
    var dateTag = "[object Date]";
    var errorTag = "[object Error]";
    var funcTag = "[object Function]";
    var mapTag = "[object Map]";
    var numberTag = "[object Number]";
    var objectTag = "[object Object]";
    var regexpTag = "[object RegExp]";
    var setTag = "[object Set]";
    var stringTag = "[object String]";
    var weakMapTag = "[object WeakMap]";
    var arrayBufferTag = "[object ArrayBuffer]";
    var dataViewTag = "[object DataView]";
    var float32Tag = "[object Float32Array]";
    var float64Tag = "[object Float64Array]";
    var int8Tag = "[object Int8Array]";
    var int16Tag = "[object Int16Array]";
    var int32Tag = "[object Int32Array]";
    var uint8Tag = "[object Uint8Array]";
    var uint8ClampedTag = "[object Uint8ClampedArray]";
    var uint16Tag = "[object Uint16Array]";
    var uint32Tag = "[object Uint32Array]";
    var typedArrayTags = {};
    typedArrayTags[float32Tag] = typedArrayTags[float64Tag] = typedArrayTags[int8Tag] = typedArrayTags[int16Tag] = typedArrayTags[int32Tag] = typedArrayTags[uint8Tag] = typedArrayTags[uint8ClampedTag] = typedArrayTags[uint16Tag] = typedArrayTags[uint32Tag] = true;
    typedArrayTags[argsTag] = typedArrayTags[arrayTag] = typedArrayTags[arrayBufferTag] = typedArrayTags[boolTag] = typedArrayTags[dataViewTag] = typedArrayTags[dateTag] = typedArrayTags[errorTag] = typedArrayTags[funcTag] = typedArrayTags[mapTag] = typedArrayTags[numberTag] = typedArrayTags[objectTag] = typedArrayTags[regexpTag] = typedArrayTags[setTag] = typedArrayTags[stringTag] = typedArrayTags[weakMapTag] = false;
    function baseIsTypedArray(value) {
      return isObjectLike(value) && isLength(value.length) && !!typedArrayTags[baseGetTag(value)];
    }
    module.exports = baseIsTypedArray;
  }
});

// node_modules/lodash/_baseUnary.js
var require_baseUnary = __commonJS({
  "node_modules/lodash/_baseUnary.js"(exports, module) {
    function baseUnary(func) {
      return function(value) {
        return func(value);
      };
    }
    module.exports = baseUnary;
  }
});

// node_modules/lodash/_nodeUtil.js
var require_nodeUtil = __commonJS({
  "node_modules/lodash/_nodeUtil.js"(exports, module) {
    var freeGlobal = require_freeGlobal();
    var freeExports = typeof exports == "object" && exports && !exports.nodeType && exports;
    var freeModule = freeExports && typeof module == "object" && module && !module.nodeType && module;
    var moduleExports = freeModule && freeModule.exports === freeExports;
    var freeProcess = moduleExports && freeGlobal.process;
    var nodeUtil = (function() {
      try {
        var types = freeModule && freeModule.require && freeModule.require("util").types;
        if (types) {
          return types;
        }
        return freeProcess && freeProcess.binding && freeProcess.binding("util");
      } catch (e) {
      }
    })();
    module.exports = nodeUtil;
  }
});

// node_modules/lodash/isTypedArray.js
var require_isTypedArray = __commonJS({
  "node_modules/lodash/isTypedArray.js"(exports, module) {
    var baseIsTypedArray = require_baseIsTypedArray();
    var baseUnary = require_baseUnary();
    var nodeUtil = require_nodeUtil();
    var nodeIsTypedArray = nodeUtil && nodeUtil.isTypedArray;
    var isTypedArray = nodeIsTypedArray ? baseUnary(nodeIsTypedArray) : baseIsTypedArray;
    module.exports = isTypedArray;
  }
});

// node_modules/lodash/_arrayLikeKeys.js
var require_arrayLikeKeys = __commonJS({
  "node_modules/lodash/_arrayLikeKeys.js"(exports, module) {
    var baseTimes = require_baseTimes();
    var isArguments = require_isArguments();
    var isArray = require_isArray();
    var isBuffer = require_isBuffer();
    var isIndex = require_isIndex();
    var isTypedArray = require_isTypedArray();
    var objectProto = Object.prototype;
    var hasOwnProperty = objectProto.hasOwnProperty;
    function arrayLikeKeys(value, inherited) {
      var isArr = isArray(value), isArg = !isArr && isArguments(value), isBuff = !isArr && !isArg && isBuffer(value), isType = !isArr && !isArg && !isBuff && isTypedArray(value), skipIndexes = isArr || isArg || isBuff || isType, result = skipIndexes ? baseTimes(value.length, String) : [], length = result.length;
      for (var key in value) {
        if ((inherited || hasOwnProperty.call(value, key)) && !(skipIndexes && // Safari 9 has enumerable `arguments.length` in strict mode.
        (key == "length" || // Node.js 0.10 has enumerable non-index properties on buffers.
        isBuff && (key == "offset" || key == "parent") || // PhantomJS 2 has enumerable non-index properties on typed arrays.
        isType && (key == "buffer" || key == "byteLength" || key == "byteOffset") || // Skip index properties.
        isIndex(key, length)))) {
          result.push(key);
        }
      }
      return result;
    }
    module.exports = arrayLikeKeys;
  }
});

// node_modules/lodash/_isPrototype.js
var require_isPrototype = __commonJS({
  "node_modules/lodash/_isPrototype.js"(exports, module) {
    var objectProto = Object.prototype;
    function isPrototype(value) {
      var Ctor = value && value.constructor, proto = typeof Ctor == "function" && Ctor.prototype || objectProto;
      return value === proto;
    }
    module.exports = isPrototype;
  }
});

// node_modules/lodash/_overArg.js
var require_overArg = __commonJS({
  "node_modules/lodash/_overArg.js"(exports, module) {
    function overArg(func, transform) {
      return function(arg) {
        return func(transform(arg));
      };
    }
    module.exports = overArg;
  }
});

// node_modules/lodash/_nativeKeys.js
var require_nativeKeys = __commonJS({
  "node_modules/lodash/_nativeKeys.js"(exports, module) {
    var overArg = require_overArg();
    var nativeKeys = overArg(Object.keys, Object);
    module.exports = nativeKeys;
  }
});

// node_modules/lodash/_baseKeys.js
var require_baseKeys = __commonJS({
  "node_modules/lodash/_baseKeys.js"(exports, module) {
    var isPrototype = require_isPrototype();
    var nativeKeys = require_nativeKeys();
    var objectProto = Object.prototype;
    var hasOwnProperty = objectProto.hasOwnProperty;
    function baseKeys(object) {
      if (!isPrototype(object)) {
        return nativeKeys(object);
      }
      var result = [];
      for (var key in Object(object)) {
        if (hasOwnProperty.call(object, key) && key != "constructor") {
          result.push(key);
        }
      }
      return result;
    }
    module.exports = baseKeys;
  }
});

// node_modules/lodash/isArrayLike.js
var require_isArrayLike = __commonJS({
  "node_modules/lodash/isArrayLike.js"(exports, module) {
    var isFunction = require_isFunction();
    var isLength = require_isLength();
    function isArrayLike(value) {
      return value != null && isLength(value.length) && !isFunction(value);
    }
    module.exports = isArrayLike;
  }
});

// node_modules/lodash/keys.js
var require_keys = __commonJS({
  "node_modules/lodash/keys.js"(exports, module) {
    var arrayLikeKeys = require_arrayLikeKeys();
    var baseKeys = require_baseKeys();
    var isArrayLike = require_isArrayLike();
    function keys(object) {
      return isArrayLike(object) ? arrayLikeKeys(object) : baseKeys(object);
    }
    module.exports = keys;
  }
});

// node_modules/lodash/_baseAssign.js
var require_baseAssign = __commonJS({
  "node_modules/lodash/_baseAssign.js"(exports, module) {
    var copyObject = require_copyObject();
    var keys = require_keys();
    function baseAssign(object, source) {
      return object && copyObject(source, keys(source), object);
    }
    module.exports = baseAssign;
  }
});

// node_modules/lodash/_nativeKeysIn.js
var require_nativeKeysIn = __commonJS({
  "node_modules/lodash/_nativeKeysIn.js"(exports, module) {
    function nativeKeysIn(object) {
      var result = [];
      if (object != null) {
        for (var key in Object(object)) {
          result.push(key);
        }
      }
      return result;
    }
    module.exports = nativeKeysIn;
  }
});

// node_modules/lodash/_baseKeysIn.js
var require_baseKeysIn = __commonJS({
  "node_modules/lodash/_baseKeysIn.js"(exports, module) {
    var isObject = require_isObject();
    var isPrototype = require_isPrototype();
    var nativeKeysIn = require_nativeKeysIn();
    var objectProto = Object.prototype;
    var hasOwnProperty = objectProto.hasOwnProperty;
    function baseKeysIn(object) {
      if (!isObject(object)) {
        return nativeKeysIn(object);
      }
      var isProto = isPrototype(object), result = [];
      for (var key in object) {
        if (!(key == "constructor" && (isProto || !hasOwnProperty.call(object, key)))) {
          result.push(key);
        }
      }
      return result;
    }
    module.exports = baseKeysIn;
  }
});

// node_modules/lodash/keysIn.js
var require_keysIn = __commonJS({
  "node_modules/lodash/keysIn.js"(exports, module) {
    var arrayLikeKeys = require_arrayLikeKeys();
    var baseKeysIn = require_baseKeysIn();
    var isArrayLike = require_isArrayLike();
    function keysIn(object) {
      return isArrayLike(object) ? arrayLikeKeys(object, true) : baseKeysIn(object);
    }
    module.exports = keysIn;
  }
});

// node_modules/lodash/_baseAssignIn.js
var require_baseAssignIn = __commonJS({
  "node_modules/lodash/_baseAssignIn.js"(exports, module) {
    var copyObject = require_copyObject();
    var keysIn = require_keysIn();
    function baseAssignIn(object, source) {
      return object && copyObject(source, keysIn(source), object);
    }
    module.exports = baseAssignIn;
  }
});

// node_modules/lodash/_cloneBuffer.js
var require_cloneBuffer = __commonJS({
  "node_modules/lodash/_cloneBuffer.js"(exports, module) {
    var root = require_root();
    var freeExports = typeof exports == "object" && exports && !exports.nodeType && exports;
    var freeModule = freeExports && typeof module == "object" && module && !module.nodeType && module;
    var moduleExports = freeModule && freeModule.exports === freeExports;
    var Buffer2 = moduleExports ? root.Buffer : void 0;
    var allocUnsafe = Buffer2 ? Buffer2.allocUnsafe : void 0;
    function cloneBuffer(buffer, isDeep) {
      if (isDeep) {
        return buffer.slice();
      }
      var length = buffer.length, result = allocUnsafe ? allocUnsafe(length) : new buffer.constructor(length);
      buffer.copy(result);
      return result;
    }
    module.exports = cloneBuffer;
  }
});

// node_modules/lodash/_copyArray.js
var require_copyArray = __commonJS({
  "node_modules/lodash/_copyArray.js"(exports, module) {
    function copyArray(source, array) {
      var index = -1, length = source.length;
      array || (array = Array(length));
      while (++index < length) {
        array[index] = source[index];
      }
      return array;
    }
    module.exports = copyArray;
  }
});

// node_modules/lodash/_arrayFilter.js
var require_arrayFilter = __commonJS({
  "node_modules/lodash/_arrayFilter.js"(exports, module) {
    function arrayFilter(array, predicate) {
      var index = -1, length = array == null ? 0 : array.length, resIndex = 0, result = [];
      while (++index < length) {
        var value = array[index];
        if (predicate(value, index, array)) {
          result[resIndex++] = value;
        }
      }
      return result;
    }
    module.exports = arrayFilter;
  }
});

// node_modules/lodash/stubArray.js
var require_stubArray = __commonJS({
  "node_modules/lodash/stubArray.js"(exports, module) {
    function stubArray() {
      return [];
    }
    module.exports = stubArray;
  }
});

// node_modules/lodash/_getSymbols.js
var require_getSymbols = __commonJS({
  "node_modules/lodash/_getSymbols.js"(exports, module) {
    var arrayFilter = require_arrayFilter();
    var stubArray = require_stubArray();
    var objectProto = Object.prototype;
    var propertyIsEnumerable = objectProto.propertyIsEnumerable;
    var nativeGetSymbols = Object.getOwnPropertySymbols;
    var getSymbols = !nativeGetSymbols ? stubArray : function(object) {
      if (object == null) {
        return [];
      }
      object = Object(object);
      return arrayFilter(nativeGetSymbols(object), function(symbol) {
        return propertyIsEnumerable.call(object, symbol);
      });
    };
    module.exports = getSymbols;
  }
});

// node_modules/lodash/_copySymbols.js
var require_copySymbols = __commonJS({
  "node_modules/lodash/_copySymbols.js"(exports, module) {
    var copyObject = require_copyObject();
    var getSymbols = require_getSymbols();
    function copySymbols(source, object) {
      return copyObject(source, getSymbols(source), object);
    }
    module.exports = copySymbols;
  }
});

// node_modules/lodash/_arrayPush.js
var require_arrayPush = __commonJS({
  "node_modules/lodash/_arrayPush.js"(exports, module) {
    function arrayPush(array, values) {
      var index = -1, length = values.length, offset = array.length;
      while (++index < length) {
        array[offset + index] = values[index];
      }
      return array;
    }
    module.exports = arrayPush;
  }
});

// node_modules/lodash/_getPrototype.js
var require_getPrototype = __commonJS({
  "node_modules/lodash/_getPrototype.js"(exports, module) {
    var overArg = require_overArg();
    var getPrototype = overArg(Object.getPrototypeOf, Object);
    module.exports = getPrototype;
  }
});

// node_modules/lodash/_getSymbolsIn.js
var require_getSymbolsIn = __commonJS({
  "node_modules/lodash/_getSymbolsIn.js"(exports, module) {
    var arrayPush = require_arrayPush();
    var getPrototype = require_getPrototype();
    var getSymbols = require_getSymbols();
    var stubArray = require_stubArray();
    var nativeGetSymbols = Object.getOwnPropertySymbols;
    var getSymbolsIn = !nativeGetSymbols ? stubArray : function(object) {
      var result = [];
      while (object) {
        arrayPush(result, getSymbols(object));
        object = getPrototype(object);
      }
      return result;
    };
    module.exports = getSymbolsIn;
  }
});

// node_modules/lodash/_copySymbolsIn.js
var require_copySymbolsIn = __commonJS({
  "node_modules/lodash/_copySymbolsIn.js"(exports, module) {
    var copyObject = require_copyObject();
    var getSymbolsIn = require_getSymbolsIn();
    function copySymbolsIn(source, object) {
      return copyObject(source, getSymbolsIn(source), object);
    }
    module.exports = copySymbolsIn;
  }
});

// node_modules/lodash/_baseGetAllKeys.js
var require_baseGetAllKeys = __commonJS({
  "node_modules/lodash/_baseGetAllKeys.js"(exports, module) {
    var arrayPush = require_arrayPush();
    var isArray = require_isArray();
    function baseGetAllKeys(object, keysFunc, symbolsFunc) {
      var result = keysFunc(object);
      return isArray(object) ? result : arrayPush(result, symbolsFunc(object));
    }
    module.exports = baseGetAllKeys;
  }
});

// node_modules/lodash/_getAllKeys.js
var require_getAllKeys = __commonJS({
  "node_modules/lodash/_getAllKeys.js"(exports, module) {
    var baseGetAllKeys = require_baseGetAllKeys();
    var getSymbols = require_getSymbols();
    var keys = require_keys();
    function getAllKeys(object) {
      return baseGetAllKeys(object, keys, getSymbols);
    }
    module.exports = getAllKeys;
  }
});

// node_modules/lodash/_getAllKeysIn.js
var require_getAllKeysIn = __commonJS({
  "node_modules/lodash/_getAllKeysIn.js"(exports, module) {
    var baseGetAllKeys = require_baseGetAllKeys();
    var getSymbolsIn = require_getSymbolsIn();
    var keysIn = require_keysIn();
    function getAllKeysIn(object) {
      return baseGetAllKeys(object, keysIn, getSymbolsIn);
    }
    module.exports = getAllKeysIn;
  }
});

// node_modules/lodash/_DataView.js
var require_DataView = __commonJS({
  "node_modules/lodash/_DataView.js"(exports, module) {
    var getNative = require_getNative();
    var root = require_root();
    var DataView = getNative(root, "DataView");
    module.exports = DataView;
  }
});

// node_modules/lodash/_Promise.js
var require_Promise = __commonJS({
  "node_modules/lodash/_Promise.js"(exports, module) {
    var getNative = require_getNative();
    var root = require_root();
    var Promise2 = getNative(root, "Promise");
    module.exports = Promise2;
  }
});

// node_modules/lodash/_Set.js
var require_Set = __commonJS({
  "node_modules/lodash/_Set.js"(exports, module) {
    var getNative = require_getNative();
    var root = require_root();
    var Set = getNative(root, "Set");
    module.exports = Set;
  }
});

// node_modules/lodash/_WeakMap.js
var require_WeakMap = __commonJS({
  "node_modules/lodash/_WeakMap.js"(exports, module) {
    var getNative = require_getNative();
    var root = require_root();
    var WeakMap2 = getNative(root, "WeakMap");
    module.exports = WeakMap2;
  }
});

// node_modules/lodash/_getTag.js
var require_getTag = __commonJS({
  "node_modules/lodash/_getTag.js"(exports, module) {
    var DataView = require_DataView();
    var Map = require_Map();
    var Promise2 = require_Promise();
    var Set = require_Set();
    var WeakMap2 = require_WeakMap();
    var baseGetTag = require_baseGetTag();
    var toSource = require_toSource();
    var mapTag = "[object Map]";
    var objectTag = "[object Object]";
    var promiseTag = "[object Promise]";
    var setTag = "[object Set]";
    var weakMapTag = "[object WeakMap]";
    var dataViewTag = "[object DataView]";
    var dataViewCtorString = toSource(DataView);
    var mapCtorString = toSource(Map);
    var promiseCtorString = toSource(Promise2);
    var setCtorString = toSource(Set);
    var weakMapCtorString = toSource(WeakMap2);
    var getTag = baseGetTag;
    if (DataView && getTag(new DataView(new ArrayBuffer(1))) != dataViewTag || Map && getTag(new Map()) != mapTag || Promise2 && getTag(Promise2.resolve()) != promiseTag || Set && getTag(new Set()) != setTag || WeakMap2 && getTag(new WeakMap2()) != weakMapTag) {
      getTag = function(value) {
        var result = baseGetTag(value), Ctor = result == objectTag ? value.constructor : void 0, ctorString = Ctor ? toSource(Ctor) : "";
        if (ctorString) {
          switch (ctorString) {
            case dataViewCtorString:
              return dataViewTag;
            case mapCtorString:
              return mapTag;
            case promiseCtorString:
              return promiseTag;
            case setCtorString:
              return setTag;
            case weakMapCtorString:
              return weakMapTag;
          }
        }
        return result;
      };
    }
    module.exports = getTag;
  }
});

// node_modules/lodash/_initCloneArray.js
var require_initCloneArray = __commonJS({
  "node_modules/lodash/_initCloneArray.js"(exports, module) {
    var objectProto = Object.prototype;
    var hasOwnProperty = objectProto.hasOwnProperty;
    function initCloneArray(array) {
      var length = array.length, result = new array.constructor(length);
      if (length && typeof array[0] == "string" && hasOwnProperty.call(array, "index")) {
        result.index = array.index;
        result.input = array.input;
      }
      return result;
    }
    module.exports = initCloneArray;
  }
});

// node_modules/lodash/_Uint8Array.js
var require_Uint8Array = __commonJS({
  "node_modules/lodash/_Uint8Array.js"(exports, module) {
    var root = require_root();
    var Uint8Array2 = root.Uint8Array;
    module.exports = Uint8Array2;
  }
});

// node_modules/lodash/_cloneArrayBuffer.js
var require_cloneArrayBuffer = __commonJS({
  "node_modules/lodash/_cloneArrayBuffer.js"(exports, module) {
    var Uint8Array2 = require_Uint8Array();
    function cloneArrayBuffer(arrayBuffer) {
      var result = new arrayBuffer.constructor(arrayBuffer.byteLength);
      new Uint8Array2(result).set(new Uint8Array2(arrayBuffer));
      return result;
    }
    module.exports = cloneArrayBuffer;
  }
});

// node_modules/lodash/_cloneDataView.js
var require_cloneDataView = __commonJS({
  "node_modules/lodash/_cloneDataView.js"(exports, module) {
    var cloneArrayBuffer = require_cloneArrayBuffer();
    function cloneDataView(dataView, isDeep) {
      var buffer = isDeep ? cloneArrayBuffer(dataView.buffer) : dataView.buffer;
      return new dataView.constructor(buffer, dataView.byteOffset, dataView.byteLength);
    }
    module.exports = cloneDataView;
  }
});

// node_modules/lodash/_cloneRegExp.js
var require_cloneRegExp = __commonJS({
  "node_modules/lodash/_cloneRegExp.js"(exports, module) {
    var reFlags = /\w*$/;
    function cloneRegExp(regexp) {
      var result = new regexp.constructor(regexp.source, reFlags.exec(regexp));
      result.lastIndex = regexp.lastIndex;
      return result;
    }
    module.exports = cloneRegExp;
  }
});

// node_modules/lodash/_cloneSymbol.js
var require_cloneSymbol = __commonJS({
  "node_modules/lodash/_cloneSymbol.js"(exports, module) {
    var Symbol2 = require_Symbol();
    var symbolProto = Symbol2 ? Symbol2.prototype : void 0;
    var symbolValueOf = symbolProto ? symbolProto.valueOf : void 0;
    function cloneSymbol(symbol) {
      return symbolValueOf ? Object(symbolValueOf.call(symbol)) : {};
    }
    module.exports = cloneSymbol;
  }
});

// node_modules/lodash/_cloneTypedArray.js
var require_cloneTypedArray = __commonJS({
  "node_modules/lodash/_cloneTypedArray.js"(exports, module) {
    var cloneArrayBuffer = require_cloneArrayBuffer();
    function cloneTypedArray(typedArray, isDeep) {
      var buffer = isDeep ? cloneArrayBuffer(typedArray.buffer) : typedArray.buffer;
      return new typedArray.constructor(buffer, typedArray.byteOffset, typedArray.length);
    }
    module.exports = cloneTypedArray;
  }
});

// node_modules/lodash/_initCloneByTag.js
var require_initCloneByTag = __commonJS({
  "node_modules/lodash/_initCloneByTag.js"(exports, module) {
    var cloneArrayBuffer = require_cloneArrayBuffer();
    var cloneDataView = require_cloneDataView();
    var cloneRegExp = require_cloneRegExp();
    var cloneSymbol = require_cloneSymbol();
    var cloneTypedArray = require_cloneTypedArray();
    var boolTag = "[object Boolean]";
    var dateTag = "[object Date]";
    var mapTag = "[object Map]";
    var numberTag = "[object Number]";
    var regexpTag = "[object RegExp]";
    var setTag = "[object Set]";
    var stringTag = "[object String]";
    var symbolTag = "[object Symbol]";
    var arrayBufferTag = "[object ArrayBuffer]";
    var dataViewTag = "[object DataView]";
    var float32Tag = "[object Float32Array]";
    var float64Tag = "[object Float64Array]";
    var int8Tag = "[object Int8Array]";
    var int16Tag = "[object Int16Array]";
    var int32Tag = "[object Int32Array]";
    var uint8Tag = "[object Uint8Array]";
    var uint8ClampedTag = "[object Uint8ClampedArray]";
    var uint16Tag = "[object Uint16Array]";
    var uint32Tag = "[object Uint32Array]";
    function initCloneByTag(object, tag, isDeep) {
      var Ctor = object.constructor;
      switch (tag) {
        case arrayBufferTag:
          return cloneArrayBuffer(object);
        case boolTag:
        case dateTag:
          return new Ctor(+object);
        case dataViewTag:
          return cloneDataView(object, isDeep);
        case float32Tag:
        case float64Tag:
        case int8Tag:
        case int16Tag:
        case int32Tag:
        case uint8Tag:
        case uint8ClampedTag:
        case uint16Tag:
        case uint32Tag:
          return cloneTypedArray(object, isDeep);
        case mapTag:
          return new Ctor();
        case numberTag:
        case stringTag:
          return new Ctor(object);
        case regexpTag:
          return cloneRegExp(object);
        case setTag:
          return new Ctor();
        case symbolTag:
          return cloneSymbol(object);
      }
    }
    module.exports = initCloneByTag;
  }
});

// node_modules/lodash/_baseCreate.js
var require_baseCreate = __commonJS({
  "node_modules/lodash/_baseCreate.js"(exports, module) {
    var isObject = require_isObject();
    var objectCreate = Object.create;
    var baseCreate = /* @__PURE__ */ (function() {
      function object() {
      }
      return function(proto) {
        if (!isObject(proto)) {
          return {};
        }
        if (objectCreate) {
          return objectCreate(proto);
        }
        object.prototype = proto;
        var result = new object();
        object.prototype = void 0;
        return result;
      };
    })();
    module.exports = baseCreate;
  }
});

// node_modules/lodash/_initCloneObject.js
var require_initCloneObject = __commonJS({
  "node_modules/lodash/_initCloneObject.js"(exports, module) {
    var baseCreate = require_baseCreate();
    var getPrototype = require_getPrototype();
    var isPrototype = require_isPrototype();
    function initCloneObject(object) {
      return typeof object.constructor == "function" && !isPrototype(object) ? baseCreate(getPrototype(object)) : {};
    }
    module.exports = initCloneObject;
  }
});

// node_modules/lodash/_baseIsMap.js
var require_baseIsMap = __commonJS({
  "node_modules/lodash/_baseIsMap.js"(exports, module) {
    var getTag = require_getTag();
    var isObjectLike = require_isObjectLike();
    var mapTag = "[object Map]";
    function baseIsMap(value) {
      return isObjectLike(value) && getTag(value) == mapTag;
    }
    module.exports = baseIsMap;
  }
});

// node_modules/lodash/isMap.js
var require_isMap = __commonJS({
  "node_modules/lodash/isMap.js"(exports, module) {
    var baseIsMap = require_baseIsMap();
    var baseUnary = require_baseUnary();
    var nodeUtil = require_nodeUtil();
    var nodeIsMap = nodeUtil && nodeUtil.isMap;
    var isMap = nodeIsMap ? baseUnary(nodeIsMap) : baseIsMap;
    module.exports = isMap;
  }
});

// node_modules/lodash/_baseIsSet.js
var require_baseIsSet = __commonJS({
  "node_modules/lodash/_baseIsSet.js"(exports, module) {
    var getTag = require_getTag();
    var isObjectLike = require_isObjectLike();
    var setTag = "[object Set]";
    function baseIsSet(value) {
      return isObjectLike(value) && getTag(value) == setTag;
    }
    module.exports = baseIsSet;
  }
});

// node_modules/lodash/isSet.js
var require_isSet = __commonJS({
  "node_modules/lodash/isSet.js"(exports, module) {
    var baseIsSet = require_baseIsSet();
    var baseUnary = require_baseUnary();
    var nodeUtil = require_nodeUtil();
    var nodeIsSet = nodeUtil && nodeUtil.isSet;
    var isSet = nodeIsSet ? baseUnary(nodeIsSet) : baseIsSet;
    module.exports = isSet;
  }
});

// node_modules/lodash/_baseClone.js
var require_baseClone = __commonJS({
  "node_modules/lodash/_baseClone.js"(exports, module) {
    var Stack = require_Stack();
    var arrayEach = require_arrayEach();
    var assignValue = require_assignValue();
    var baseAssign = require_baseAssign();
    var baseAssignIn = require_baseAssignIn();
    var cloneBuffer = require_cloneBuffer();
    var copyArray = require_copyArray();
    var copySymbols = require_copySymbols();
    var copySymbolsIn = require_copySymbolsIn();
    var getAllKeys = require_getAllKeys();
    var getAllKeysIn = require_getAllKeysIn();
    var getTag = require_getTag();
    var initCloneArray = require_initCloneArray();
    var initCloneByTag = require_initCloneByTag();
    var initCloneObject = require_initCloneObject();
    var isArray = require_isArray();
    var isBuffer = require_isBuffer();
    var isMap = require_isMap();
    var isObject = require_isObject();
    var isSet = require_isSet();
    var keys = require_keys();
    var keysIn = require_keysIn();
    var CLONE_DEEP_FLAG = 1;
    var CLONE_FLAT_FLAG = 2;
    var CLONE_SYMBOLS_FLAG = 4;
    var argsTag = "[object Arguments]";
    var arrayTag = "[object Array]";
    var boolTag = "[object Boolean]";
    var dateTag = "[object Date]";
    var errorTag = "[object Error]";
    var funcTag = "[object Function]";
    var genTag = "[object GeneratorFunction]";
    var mapTag = "[object Map]";
    var numberTag = "[object Number]";
    var objectTag = "[object Object]";
    var regexpTag = "[object RegExp]";
    var setTag = "[object Set]";
    var stringTag = "[object String]";
    var symbolTag = "[object Symbol]";
    var weakMapTag = "[object WeakMap]";
    var arrayBufferTag = "[object ArrayBuffer]";
    var dataViewTag = "[object DataView]";
    var float32Tag = "[object Float32Array]";
    var float64Tag = "[object Float64Array]";
    var int8Tag = "[object Int8Array]";
    var int16Tag = "[object Int16Array]";
    var int32Tag = "[object Int32Array]";
    var uint8Tag = "[object Uint8Array]";
    var uint8ClampedTag = "[object Uint8ClampedArray]";
    var uint16Tag = "[object Uint16Array]";
    var uint32Tag = "[object Uint32Array]";
    var cloneableTags = {};
    cloneableTags[argsTag] = cloneableTags[arrayTag] = cloneableTags[arrayBufferTag] = cloneableTags[dataViewTag] = cloneableTags[boolTag] = cloneableTags[dateTag] = cloneableTags[float32Tag] = cloneableTags[float64Tag] = cloneableTags[int8Tag] = cloneableTags[int16Tag] = cloneableTags[int32Tag] = cloneableTags[mapTag] = cloneableTags[numberTag] = cloneableTags[objectTag] = cloneableTags[regexpTag] = cloneableTags[setTag] = cloneableTags[stringTag] = cloneableTags[symbolTag] = cloneableTags[uint8Tag] = cloneableTags[uint8ClampedTag] = cloneableTags[uint16Tag] = cloneableTags[uint32Tag] = true;
    cloneableTags[errorTag] = cloneableTags[funcTag] = cloneableTags[weakMapTag] = false;
    function baseClone(value, bitmask, customizer, key, object, stack) {
      var result, isDeep = bitmask & CLONE_DEEP_FLAG, isFlat = bitmask & CLONE_FLAT_FLAG, isFull = bitmask & CLONE_SYMBOLS_FLAG;
      if (customizer) {
        result = object ? customizer(value, key, object, stack) : customizer(value);
      }
      if (result !== void 0) {
        return result;
      }
      if (!isObject(value)) {
        return value;
      }
      var isArr = isArray(value);
      if (isArr) {
        result = initCloneArray(value);
        if (!isDeep) {
          return copyArray(value, result);
        }
      } else {
        var tag = getTag(value), isFunc = tag == funcTag || tag == genTag;
        if (isBuffer(value)) {
          return cloneBuffer(value, isDeep);
        }
        if (tag == objectTag || tag == argsTag || isFunc && !object) {
          result = isFlat || isFunc ? {} : initCloneObject(value);
          if (!isDeep) {
            return isFlat ? copySymbolsIn(value, baseAssignIn(result, value)) : copySymbols(value, baseAssign(result, value));
          }
        } else {
          if (!cloneableTags[tag]) {
            return object ? value : {};
          }
          result = initCloneByTag(value, tag, isDeep);
        }
      }
      stack || (stack = new Stack());
      var stacked = stack.get(value);
      if (stacked) {
        return stacked;
      }
      stack.set(value, result);
      if (isSet(value)) {
        value.forEach(function(subValue) {
          result.add(baseClone(subValue, bitmask, customizer, subValue, value, stack));
        });
      } else if (isMap(value)) {
        value.forEach(function(subValue, key2) {
          result.set(key2, baseClone(subValue, bitmask, customizer, key2, value, stack));
        });
      }
      var keysFunc = isFull ? isFlat ? getAllKeysIn : getAllKeys : isFlat ? keysIn : keys;
      var props = isArr ? void 0 : keysFunc(value);
      arrayEach(props || value, function(subValue, key2) {
        if (props) {
          key2 = subValue;
          subValue = value[key2];
        }
        assignValue(result, key2, baseClone(subValue, bitmask, customizer, key2, value, stack));
      });
      return result;
    }
    module.exports = baseClone;
  }
});

// node_modules/lodash/cloneDeep.js
var require_cloneDeep = __commonJS({
  "node_modules/lodash/cloneDeep.js"(exports, module) {
    var baseClone = require_baseClone();
    var CLONE_DEEP_FLAG = 1;
    var CLONE_SYMBOLS_FLAG = 4;
    function cloneDeep(value) {
      return baseClone(value, CLONE_DEEP_FLAG | CLONE_SYMBOLS_FLAG);
    }
    module.exports = cloneDeep;
  }
});

// node_modules/dxf/lib/denormalise.js
var require_denormalise = __commonJS({
  "node_modules/dxf/lib/denormalise.js"(exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", {
      value: true
    });
    exports["default"] = void 0;
    var _cloneDeep = _interopRequireDefault(require_cloneDeep());
    var _logger = _interopRequireDefault(require_logger());
    function _interopRequireDefault(e) {
      return e && e.__esModule ? e : { "default": e };
    }
    var _default = exports["default"] = function _default2(parseResult) {
      var blocksByName = parseResult.blocks.reduce(function(acc, b) {
        acc[b.name] = b;
        return acc;
      }, {});
      var _gatherEntities = function gatherEntities(entities, transforms) {
        var current = [];
        entities.forEach(function(e) {
          if (e.type === "INSERT") {
            var _insert$rowCount, _insert$columnCount, _insert$rowSpacing, _insert$columnSpacing, _insert$rotation;
            var insert = e;
            var block = blocksByName[insert.block];
            if (!block) {
              _logger["default"].error("no block found for insert. block:", insert.block);
              return;
            }
            var rowCount = (_insert$rowCount = insert.rowCount) !== null && _insert$rowCount !== void 0 ? _insert$rowCount : 1;
            var columnCount = (_insert$columnCount = insert.columnCount) !== null && _insert$columnCount !== void 0 ? _insert$columnCount : 1;
            var rowSpacing = (_insert$rowSpacing = insert.rowSpacing) !== null && _insert$rowSpacing !== void 0 ? _insert$rowSpacing : 0;
            var columnSpacing = (_insert$columnSpacing = insert.columnSpacing) !== null && _insert$columnSpacing !== void 0 ? _insert$columnSpacing : 0;
            var rotation = (_insert$rotation = insert.rotation) !== null && _insert$rotation !== void 0 ? _insert$rotation : 0;
            var rowVec, colVec;
            if (rowCount > 1 || columnCount > 1) {
              var cos = Math.cos(rotation * Math.PI / 180);
              var sin = Math.sin(rotation * Math.PI / 180);
              rowVec = {
                x: -sin * rowSpacing,
                y: cos * rowSpacing
              };
              colVec = {
                x: cos * columnSpacing,
                y: sin * columnSpacing
              };
            } else {
              rowVec = {
                x: 0,
                y: 0
              };
              colVec = {
                x: 0,
                y: 0
              };
            }
            for (var r = 0; r < rowCount; r++) {
              for (var c = 0; c < columnCount; c++) {
                var t = {
                  x: insert.x + rowVec.x * r + colVec.x * c,
                  y: insert.y + rowVec.y * r + colVec.y * c,
                  scaleX: insert.scaleX,
                  scaleY: insert.scaleY,
                  scaleZ: insert.scaleZ,
                  extrusionX: insert.extrusionX,
                  extrusionY: insert.extrusionY,
                  extrusionZ: insert.extrusionZ,
                  rotation: insert.rotation
                };
                var transforms2 = transforms.slice(0);
                transforms2.push(t);
                var blockEntities = block.entities.map(function(be) {
                  var be2 = (0, _cloneDeep["default"])(be);
                  be2.layer = insert.layer;
                  switch (be2.type) {
                    case "LINE": {
                      be2.start.x -= block.x;
                      be2.start.y -= block.y;
                      be2.end.x -= block.x;
                      be2.end.y -= block.y;
                      break;
                    }
                    case "LWPOLYLINE":
                    case "POLYLINE": {
                      be2.vertices.forEach(function(v) {
                        v.x -= block.x;
                        v.y -= block.y;
                      });
                      break;
                    }
                    case "CIRCLE":
                    case "ELLIPSE":
                    case "ARC": {
                      be2.x -= block.x;
                      be2.y -= block.y;
                      break;
                    }
                    case "SPLINE": {
                      be2.controlPoints.forEach(function(cp) {
                        cp.x -= block.x;
                        cp.y -= block.y;
                      });
                      break;
                    }
                  }
                  return be2;
                });
                current = current.concat(_gatherEntities(blockEntities, transforms2));
              }
            }
          } else {
            var e2 = (0, _cloneDeep["default"])(e);
            e2.transforms = transforms.slice().reverse();
            current.push(e2);
          }
        });
        return current;
      };
      return _gatherEntities(parseResult.entities, []);
    };
  }
});

// node_modules/dxf/lib/groupEntitiesByLayer.js
var require_groupEntitiesByLayer = __commonJS({
  "node_modules/dxf/lib/groupEntitiesByLayer.js"(exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", {
      value: true
    });
    exports["default"] = void 0;
    var _default = exports["default"] = function _default2(entities) {
      return entities.reduce(function(acc, entity) {
        var layer = entity.layer;
        if (!acc[layer]) {
          acc[layer] = [];
        }
        acc[layer].push(entity);
        return acc;
      }, {});
    };
  }
});

// node_modules/vecks/lib/V2.js
var require_V2 = __commonJS({
  "node_modules/vecks/lib/V2.js"(exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", {
      value: true
    });
    exports["default"] = void 0;
    function _typeof(obj) {
      "@babel/helpers - typeof";
      if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") {
        _typeof = function _typeof2(obj2) {
          return typeof obj2;
        };
      } else {
        _typeof = function _typeof2(obj2) {
          return obj2 && typeof Symbol === "function" && obj2.constructor === Symbol && obj2 !== Symbol.prototype ? "symbol" : typeof obj2;
        };
      }
      return _typeof(obj);
    }
    function _classCallCheck(instance, Constructor) {
      if (!(instance instanceof Constructor)) {
        throw new TypeError("Cannot call a class as a function");
      }
    }
    function _defineProperties(target, props) {
      for (var i = 0; i < props.length; i++) {
        var descriptor = props[i];
        descriptor.enumerable = descriptor.enumerable || false;
        descriptor.configurable = true;
        if ("value" in descriptor) descriptor.writable = true;
        Object.defineProperty(target, descriptor.key, descriptor);
      }
    }
    function _createClass(Constructor, protoProps, staticProps) {
      if (protoProps) _defineProperties(Constructor.prototype, protoProps);
      if (staticProps) _defineProperties(Constructor, staticProps);
      return Constructor;
    }
    var V2 = /* @__PURE__ */ (function() {
      function V22(x, y) {
        _classCallCheck(this, V22);
        if (_typeof(x) === "object") {
          this.x = x.x;
          this.y = x.y;
        } else {
          this.x = x;
          this.y = y;
        }
      }
      _createClass(V22, [{
        key: "equals",
        value: function equals(other) {
          return this.x === other.x && this.y === other.y;
        }
      }, {
        key: "length",
        value: function length() {
          return Math.sqrt(this.dot(this));
        }
      }, {
        key: "neg",
        value: function neg() {
          return new V22(-this.x, -this.y);
        }
      }, {
        key: "add",
        value: function add(b) {
          return new V22(this.x + b.x, this.y + b.y);
        }
      }, {
        key: "sub",
        value: function sub(b) {
          return new V22(this.x - b.x, this.y - b.y);
        }
      }, {
        key: "multiply",
        value: function multiply(w) {
          return new V22(this.x * w, this.y * w);
        }
      }, {
        key: "norm",
        value: function norm() {
          return this.multiply(1 / this.length());
        }
      }, {
        key: "dot",
        value: function dot(b) {
          return this.x * b.x + this.y * b.y;
        }
      }]);
      return V22;
    })();
    var _default = V2;
    exports["default"] = _default;
  }
});

// node_modules/vecks/lib/V3.js
var require_V3 = __commonJS({
  "node_modules/vecks/lib/V3.js"(exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", {
      value: true
    });
    exports["default"] = void 0;
    function _typeof(obj) {
      "@babel/helpers - typeof";
      if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") {
        _typeof = function _typeof2(obj2) {
          return typeof obj2;
        };
      } else {
        _typeof = function _typeof2(obj2) {
          return obj2 && typeof Symbol === "function" && obj2.constructor === Symbol && obj2 !== Symbol.prototype ? "symbol" : typeof obj2;
        };
      }
      return _typeof(obj);
    }
    function _classCallCheck(instance, Constructor) {
      if (!(instance instanceof Constructor)) {
        throw new TypeError("Cannot call a class as a function");
      }
    }
    function _defineProperties(target, props) {
      for (var i = 0; i < props.length; i++) {
        var descriptor = props[i];
        descriptor.enumerable = descriptor.enumerable || false;
        descriptor.configurable = true;
        if ("value" in descriptor) descriptor.writable = true;
        Object.defineProperty(target, descriptor.key, descriptor);
      }
    }
    function _createClass(Constructor, protoProps, staticProps) {
      if (protoProps) _defineProperties(Constructor.prototype, protoProps);
      if (staticProps) _defineProperties(Constructor, staticProps);
      return Constructor;
    }
    var V3 = /* @__PURE__ */ (function() {
      function V32(x, y, z) {
        _classCallCheck(this, V32);
        if (_typeof(x) === "object") {
          this.x = x.x;
          this.y = x.y;
          this.z = x.z;
        } else if (x === void 0) {
          this.x = 0;
          this.y = 0;
          this.z = 0;
        } else {
          this.x = x;
          this.y = y;
          this.z = z;
        }
      }
      _createClass(V32, [{
        key: "equals",
        value: function equals(other, eps) {
          if (eps === void 0) {
            eps = 0;
          }
          return Math.abs(this.x - other.x) <= eps && Math.abs(this.y - other.y) <= eps && Math.abs(this.z - other.z) <= eps;
        }
      }, {
        key: "length",
        value: function length() {
          return Math.sqrt(this.dot(this));
        }
      }, {
        key: "neg",
        value: function neg() {
          return new V32(-this.x, -this.y, -this.z);
        }
      }, {
        key: "add",
        value: function add(b) {
          return new V32(this.x + b.x, this.y + b.y, this.z + b.z);
        }
      }, {
        key: "sub",
        value: function sub(b) {
          return new V32(this.x - b.x, this.y - b.y, this.z - b.z);
        }
      }, {
        key: "multiply",
        value: function multiply(w) {
          return new V32(this.x * w, this.y * w, this.z * w);
        }
      }, {
        key: "norm",
        value: function norm() {
          return this.multiply(1 / this.length());
        }
      }, {
        key: "dot",
        value: function dot(b) {
          return this.x * b.x + this.y * b.y + this.z * b.z;
        }
      }, {
        key: "cross",
        value: function cross(b) {
          return new V32(this.y * b.z - this.z * b.y, this.z * b.x - this.x * b.z, this.x * b.y - this.y * b.x);
        }
      }]);
      return V32;
    })();
    var _default = V3;
    exports["default"] = _default;
  }
});

// node_modules/vecks/lib/Box2.js
var require_Box2 = __commonJS({
  "node_modules/vecks/lib/Box2.js"(exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", {
      value: true
    });
    exports["default"] = void 0;
    var _V = _interopRequireDefault(require_V2());
    function _interopRequireDefault(obj) {
      return obj && obj.__esModule ? obj : { "default": obj };
    }
    function _typeof(obj) {
      "@babel/helpers - typeof";
      if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") {
        _typeof = function _typeof2(obj2) {
          return typeof obj2;
        };
      } else {
        _typeof = function _typeof2(obj2) {
          return obj2 && typeof Symbol === "function" && obj2.constructor === Symbol && obj2 !== Symbol.prototype ? "symbol" : typeof obj2;
        };
      }
      return _typeof(obj);
    }
    function _classCallCheck(instance, Constructor) {
      if (!(instance instanceof Constructor)) {
        throw new TypeError("Cannot call a class as a function");
      }
    }
    function _defineProperties(target, props) {
      for (var i = 0; i < props.length; i++) {
        var descriptor = props[i];
        descriptor.enumerable = descriptor.enumerable || false;
        descriptor.configurable = true;
        if ("value" in descriptor) descriptor.writable = true;
        Object.defineProperty(target, descriptor.key, descriptor);
      }
    }
    function _createClass(Constructor, protoProps, staticProps) {
      if (protoProps) _defineProperties(Constructor.prototype, protoProps);
      if (staticProps) _defineProperties(Constructor, staticProps);
      return Constructor;
    }
    var Box2 = /* @__PURE__ */ (function() {
      function Box22(min, max) {
        _classCallCheck(this, Box22);
        if (_typeof(min) === "object" && _typeof(max) === "object" && min.x !== void 0 && min.y !== void 0 && max.x !== void 0 && max.y !== void 0) {
          this.min = new _V["default"](min);
          this.max = new _V["default"](max);
          this.valid = true;
        } else if (min === void 0 && max === void 0) {
          this.min = new _V["default"](Infinity, Infinity);
          this.max = new _V["default"](-Infinity, -Infinity);
          this.valid = false;
        } else {
          throw Error("Illegal construction - must use { x, y } objects");
        }
      }
      _createClass(Box22, [{
        key: "equals",
        value: function equals(other) {
          if (!this.valid) {
            throw Error("Box2 is invalid");
          }
          return this.min.equals(other.min) && this.max.equals(other.max);
        }
      }, {
        key: "expandByPoint",
        value: function expandByPoint(p) {
          this.min = new _V["default"](Math.min(this.min.x, p.x), Math.min(this.min.y, p.y));
          this.max = new _V["default"](Math.max(this.max.x, p.x), Math.max(this.max.y, p.y));
          this.valid = true;
          return this;
        }
      }, {
        key: "expandByPoints",
        value: function expandByPoints(points) {
          var _this = this;
          points.forEach(function(point) {
            _this.expandByPoint(point);
          }, this);
          return this;
        }
      }, {
        key: "isPointInside",
        value: function isPointInside(p) {
          return p.x >= this.min.x && p.y >= this.min.y && p.x <= this.max.x && p.y <= this.max.y;
        }
      }, {
        key: "width",
        get: function get() {
          if (!this.valid) {
            throw Error("Box2 is invalid");
          }
          return this.max.x - this.min.x;
        }
      }, {
        key: "height",
        get: function get() {
          if (!this.valid) {
            throw Error("Box2 is invalid");
          }
          return this.max.y - this.min.y;
        }
      }]);
      return Box22;
    })();
    Box2.fromPoints = function(points) {
      return new Box2().expandByPoints(points);
    };
    var _default = Box2;
    exports["default"] = _default;
  }
});

// node_modules/vecks/lib/Box3.js
var require_Box3 = __commonJS({
  "node_modules/vecks/lib/Box3.js"(exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", {
      value: true
    });
    exports["default"] = void 0;
    var _V = _interopRequireDefault(require_V3());
    function _interopRequireDefault(obj) {
      return obj && obj.__esModule ? obj : { "default": obj };
    }
    function _typeof(obj) {
      "@babel/helpers - typeof";
      if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") {
        _typeof = function _typeof2(obj2) {
          return typeof obj2;
        };
      } else {
        _typeof = function _typeof2(obj2) {
          return obj2 && typeof Symbol === "function" && obj2.constructor === Symbol && obj2 !== Symbol.prototype ? "symbol" : typeof obj2;
        };
      }
      return _typeof(obj);
    }
    function _classCallCheck(instance, Constructor) {
      if (!(instance instanceof Constructor)) {
        throw new TypeError("Cannot call a class as a function");
      }
    }
    function _defineProperties(target, props) {
      for (var i = 0; i < props.length; i++) {
        var descriptor = props[i];
        descriptor.enumerable = descriptor.enumerable || false;
        descriptor.configurable = true;
        if ("value" in descriptor) descriptor.writable = true;
        Object.defineProperty(target, descriptor.key, descriptor);
      }
    }
    function _createClass(Constructor, protoProps, staticProps) {
      if (protoProps) _defineProperties(Constructor.prototype, protoProps);
      if (staticProps) _defineProperties(Constructor, staticProps);
      return Constructor;
    }
    var Box3 = /* @__PURE__ */ (function() {
      function Box32(min, max) {
        _classCallCheck(this, Box32);
        if (_typeof(min) === "object" && _typeof(max) === "object" && min.x !== void 0 && min.y !== void 0 && min.z !== void 0 && max.x !== void 0 && max.y !== void 0 && max.z !== void 0) {
          this.min = new _V["default"](min);
          this.max = new _V["default"](max);
          this.valid = true;
        } else if (min === void 0 && max === void 0) {
          this.min = new _V["default"](Infinity, Infinity, Infinity);
          this.max = new _V["default"](-Infinity, -Infinity, -Infinity);
          this.valid = false;
        } else {
          throw Error("Illegal construction - must use { x, y, z } objects");
        }
      }
      _createClass(Box32, [{
        key: "equals",
        value: function equals(other) {
          if (!this.valid) {
            throw Error("Box3 is invalid");
          }
          return this.min.equals(other.min) && this.max.equals(other.max);
        }
      }, {
        key: "expandByPoint",
        value: function expandByPoint(p) {
          this.min = new _V["default"](Math.min(this.min.x, p.x), Math.min(this.min.y, p.y), Math.min(this.min.z, p.z));
          this.max = new _V["default"](Math.max(this.max.x, p.x), Math.max(this.max.y, p.y), Math.max(this.max.z, p.z));
          this.valid = true;
          return this;
        }
      }, {
        key: "expandByPoints",
        value: function expandByPoints(points) {
          var _this = this;
          points.forEach(function(point) {
            _this.expandByPoint(point);
          }, this);
          return this;
        }
      }, {
        key: "isPointInside",
        value: function isPointInside(p) {
          return p.x >= this.min.x && p.y >= this.min.y && p.z >= this.min.z && p.x <= this.max.x && p.y <= this.max.y && p.z <= this.max.z;
        }
      }, {
        key: "width",
        get: function get() {
          if (!this.valid) {
            throw Error("Box3 is invalid");
          }
          return this.max.x - this.min.x;
        }
      }, {
        key: "depth",
        get: function get() {
          if (!this.valid) {
            throw Error("Box3 is invalid");
          }
          return this.max.y - this.min.y;
        }
      }, {
        key: "height",
        get: function get() {
          if (!this.valid) {
            throw Error("Box3 is invalid");
          }
          return this.max.z - this.min.z;
        }
      }]);
      return Box32;
    })();
    Box3.fromPoints = function(points) {
      return new Box3().expandByPoints(points);
    };
    var _default = Box3;
    exports["default"] = _default;
  }
});

// node_modules/vecks/lib/Plane3.js
var require_Plane3 = __commonJS({
  "node_modules/vecks/lib/Plane3.js"(exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", {
      value: true
    });
    exports["default"] = void 0;
    function _classCallCheck(instance, Constructor) {
      if (!(instance instanceof Constructor)) {
        throw new TypeError("Cannot call a class as a function");
      }
    }
    function _defineProperties(target, props) {
      for (var i = 0; i < props.length; i++) {
        var descriptor = props[i];
        descriptor.enumerable = descriptor.enumerable || false;
        descriptor.configurable = true;
        if ("value" in descriptor) descriptor.writable = true;
        Object.defineProperty(target, descriptor.key, descriptor);
      }
    }
    function _createClass(Constructor, protoProps, staticProps) {
      if (protoProps) _defineProperties(Constructor.prototype, protoProps);
      if (staticProps) _defineProperties(Constructor, staticProps);
      return Constructor;
    }
    var Plane3 = /* @__PURE__ */ (function() {
      function Plane32(a, b, c, d) {
        _classCallCheck(this, Plane32);
        this.a = a;
        this.b = b;
        this.c = c;
        this.d = d;
      }
      _createClass(Plane32, [{
        key: "distanceToPoint",
        value: function distanceToPoint(p0) {
          var dd = (this.a * p0.x + this.b * p0.y + this.c * p0.z + this.d) / Math.sqrt(this.a * this.a + this.b * this.b + this.c * this.c);
          return dd;
        }
      }, {
        key: "equals",
        value: function equals(other) {
          return this.a === other.a && this.b === other.b && this.c === other.c && this.d === other.d;
        }
      }, {
        key: "coPlanar",
        value: function coPlanar(other) {
          var coPlanarAndSameNormal = this.a === other.a && this.b === other.b && this.c === other.c && this.d === other.d;
          var coPlanarAndReversedNormal = this.a === -other.a && this.b === -other.b && this.c === -other.c && this.d === -other.d;
          return coPlanarAndSameNormal || coPlanarAndReversedNormal;
        }
      }]);
      return Plane32;
    })();
    Plane3.fromPointAndNormal = function(p, n) {
      var a = n.x;
      var b = n.y;
      var c = n.z;
      var d = -(p.x * a + p.y * b + p.z * c);
      return new Plane3(n.x, n.y, n.z, d);
    };
    Plane3.fromPoints = function(points) {
      var firstCross;
      for (var i = 0, il = points.length; i < il; ++i) {
        var ab = points[(i + 1) % il].sub(points[i]);
        var bc = points[(i + 2) % il].sub(points[(i + 1) % il]);
        var cross = ab.cross(bc);
        if (!(isNaN(cross.length()) || cross.length() === 0)) {
          if (!firstCross) {
            firstCross = cross.norm();
          } else {
            var same = cross.norm().equals(firstCross, 1e-6);
            var opposite = cross.neg().norm().equals(firstCross, 1e-6);
            if (!(same || opposite)) {
              throw Error("points not on a plane");
            }
          }
        }
      }
      if (!firstCross) {
        throw Error("points not on a plane");
      }
      return Plane3.fromPointAndNormal(points[0], firstCross.norm());
    };
    var _default = Plane3;
    exports["default"] = _default;
  }
});

// node_modules/vecks/lib/Quaternion.js
var require_Quaternion = __commonJS({
  "node_modules/vecks/lib/Quaternion.js"(exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", {
      value: true
    });
    exports["default"] = void 0;
    var _V = _interopRequireDefault(require_V3());
    function _interopRequireDefault(obj) {
      return obj && obj.__esModule ? obj : { "default": obj };
    }
    function _classCallCheck(instance, Constructor) {
      if (!(instance instanceof Constructor)) {
        throw new TypeError("Cannot call a class as a function");
      }
    }
    function _defineProperties(target, props) {
      for (var i = 0; i < props.length; i++) {
        var descriptor = props[i];
        descriptor.enumerable = descriptor.enumerable || false;
        descriptor.configurable = true;
        if ("value" in descriptor) descriptor.writable = true;
        Object.defineProperty(target, descriptor.key, descriptor);
      }
    }
    function _createClass(Constructor, protoProps, staticProps) {
      if (protoProps) _defineProperties(Constructor.prototype, protoProps);
      if (staticProps) _defineProperties(Constructor, staticProps);
      return Constructor;
    }
    var Quaternion = /* @__PURE__ */ (function() {
      function Quaternion2(x, y, z, w) {
        _classCallCheck(this, Quaternion2);
        this.x = x;
        this.y = y;
        this.z = z;
        this.w = w;
      }
      _createClass(Quaternion2, [{
        key: "applyToVec3",
        value: function applyToVec3(v3) {
          var x = v3.x;
          var y = v3.y;
          var z = v3.z;
          var qx = this.x;
          var qy = this.y;
          var qz = this.z;
          var qw = this.w;
          var ix = qw * x + qy * z - qz * y;
          var iy = qw * y + qz * x - qx * z;
          var iz = qw * z + qx * y - qy * x;
          var iw = -qx * x - qy * y - qz * z;
          return new _V["default"](ix * qw + iw * -qx + iy * -qz - iz * -qy, iy * qw + iw * -qy + iz * -qx - ix * -qz, iz * qw + iw * -qz + ix * -qy - iy * -qx);
        }
      }]);
      return Quaternion2;
    })();
    Quaternion.fromAxisAngle = function(axis, angle) {
      var axisNorm = axis.norm();
      var halfAngle = angle / 2;
      var s = Math.sin(halfAngle);
      return new Quaternion(axisNorm.x * s, axisNorm.y * s, axisNorm.z * s, Math.cos(halfAngle));
    };
    var _default = Quaternion;
    exports["default"] = _default;
  }
});

// node_modules/vecks/lib/Line2.js
var require_Line2 = __commonJS({
  "node_modules/vecks/lib/Line2.js"(exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", {
      value: true
    });
    exports["default"] = void 0;
    var _V = _interopRequireDefault(require_V2());
    function _interopRequireDefault(obj) {
      return obj && obj.__esModule ? obj : { "default": obj };
    }
    function _typeof(obj) {
      "@babel/helpers - typeof";
      if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") {
        _typeof = function _typeof2(obj2) {
          return typeof obj2;
        };
      } else {
        _typeof = function _typeof2(obj2) {
          return obj2 && typeof Symbol === "function" && obj2.constructor === Symbol && obj2 !== Symbol.prototype ? "symbol" : typeof obj2;
        };
      }
      return _typeof(obj);
    }
    function _classCallCheck(instance, Constructor) {
      if (!(instance instanceof Constructor)) {
        throw new TypeError("Cannot call a class as a function");
      }
    }
    function _defineProperties(target, props) {
      for (var i = 0; i < props.length; i++) {
        var descriptor = props[i];
        descriptor.enumerable = descriptor.enumerable || false;
        descriptor.configurable = true;
        if ("value" in descriptor) descriptor.writable = true;
        Object.defineProperty(target, descriptor.key, descriptor);
      }
    }
    function _createClass(Constructor, protoProps, staticProps) {
      if (protoProps) _defineProperties(Constructor.prototype, protoProps);
      if (staticProps) _defineProperties(Constructor, staticProps);
      return Constructor;
    }
    var turn = function turn2(p1, p2, p3) {
      var a = p1.x;
      var b = p1.y;
      var c = p2.x;
      var d = p2.y;
      var e = p3.x;
      var f = p3.y;
      var m = (f - b) * (c - a);
      var n = (d - b) * (e - a);
      return m > n + Number.EPSILON ? 1 : m + Number.EPSILON < n ? -1 : 0;
    };
    var isIntersect = function isIntersect2(e1, e2) {
      var p1 = e1.a;
      var p2 = e1.b;
      var p3 = e2.a;
      var p4 = e2.b;
      return turn(p1, p3, p4) !== turn(p2, p3, p4) && turn(p1, p2, p3) !== turn(p1, p2, p4);
    };
    var _getIntersection = function getIntersection(m, n) {
      var x1 = m.a.x;
      var x2 = m.b.x;
      var y1 = m.a.y;
      var y2 = m.b.y;
      var x3 = n.a.x;
      var x4 = n.b.x;
      var y3 = n.a.y;
      var y4 = n.b.y;
      var x12 = x1 - x2;
      var x34 = x3 - x4;
      var y12 = y1 - y2;
      var y34 = y3 - y4;
      var c = x12 * y34 - y12 * x34;
      var px = ((x1 * y2 - y1 * x2) * x34 - x12 * (x3 * y4 - y3 * x4)) / c;
      var py = ((x1 * y2 - y1 * x2) * y34 - y12 * (x3 * y4 - y3 * x4)) / c;
      if (isNaN(px) || isNaN(py)) {
        return null;
      } else {
        return new _V["default"](px, py);
      }
    };
    var dist = function dist2(a, b) {
      return Math.sqrt(Math.pow(a.x - b.x, 2) + Math.pow(a.y - b.y, 2));
    };
    var Line2 = /* @__PURE__ */ (function() {
      function Line22(a, b) {
        _classCallCheck(this, Line22);
        if (_typeof(a) !== "object" || a.x === void 0 || a.y === void 0) {
          throw Error("expected first argument to have x and y properties");
        }
        if (_typeof(b) !== "object" || b.x === void 0 || b.y === void 0) {
          throw Error("expected second argument to have x and y properties");
        }
        this.a = new _V["default"](a);
        this.b = new _V["default"](b);
      }
      _createClass(Line22, [{
        key: "length",
        value: function length() {
          return this.a.sub(this.b).length();
        }
      }, {
        key: "intersects",
        value: function intersects(other) {
          if (!(other instanceof Line22)) {
            throw new Error("expected argument to be an instance of vecks.Line2");
          }
          return isIntersect(this, other);
        }
      }, {
        key: "getIntersection",
        value: function getIntersection(other) {
          if (this.intersects(other)) {
            return _getIntersection(this, other);
          } else {
            return null;
          }
        }
      }, {
        key: "containsPoint",
        value: function containsPoint(point) {
          var eps = arguments.length > 1 && arguments[1] !== void 0 ? arguments[1] : 1e-12;
          return Math.abs(dist(this.a, this.b) - dist(point, this.a) - dist(point, this.b)) < eps;
        }
      }]);
      return Line22;
    })();
    var _default = Line2;
    exports["default"] = _default;
  }
});

// node_modules/vecks/lib/Line3.js
var require_Line3 = __commonJS({
  "node_modules/vecks/lib/Line3.js"(exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", {
      value: true
    });
    exports["default"] = void 0;
    var _V = _interopRequireDefault(require_V3());
    function _interopRequireDefault(obj) {
      return obj && obj.__esModule ? obj : { "default": obj };
    }
    function _typeof(obj) {
      "@babel/helpers - typeof";
      if (typeof Symbol === "function" && typeof Symbol.iterator === "symbol") {
        _typeof = function _typeof2(obj2) {
          return typeof obj2;
        };
      } else {
        _typeof = function _typeof2(obj2) {
          return obj2 && typeof Symbol === "function" && obj2.constructor === Symbol && obj2 !== Symbol.prototype ? "symbol" : typeof obj2;
        };
      }
      return _typeof(obj);
    }
    function _classCallCheck(instance, Constructor) {
      if (!(instance instanceof Constructor)) {
        throw new TypeError("Cannot call a class as a function");
      }
    }
    function _defineProperties(target, props) {
      for (var i = 0; i < props.length; i++) {
        var descriptor = props[i];
        descriptor.enumerable = descriptor.enumerable || false;
        descriptor.configurable = true;
        if ("value" in descriptor) descriptor.writable = true;
        Object.defineProperty(target, descriptor.key, descriptor);
      }
    }
    function _createClass(Constructor, protoProps, staticProps) {
      if (protoProps) _defineProperties(Constructor.prototype, protoProps);
      if (staticProps) _defineProperties(Constructor, staticProps);
      return Constructor;
    }
    var dist = function dist2(a, b) {
      return Math.sqrt(Math.pow(a.x - b.x, 2) + Math.pow(a.y - b.y, 2) + Math.pow(a.z - b.z, 2));
    };
    var Line3 = /* @__PURE__ */ (function() {
      function Line32(a, b) {
        _classCallCheck(this, Line32);
        if (_typeof(a) !== "object" || a.x === void 0 || a.y === void 0 || a.z === void 0) {
          throw Error("expected first argument to have x, y and z properties");
        }
        if (_typeof(b) !== "object" || b.x === void 0 || b.y === void 0 || b.y === void 0) {
          throw Error("expected second argument to have x, y and z properties");
        }
        this.a = new _V["default"](a);
        this.b = new _V["default"](b);
      }
      _createClass(Line32, [{
        key: "length",
        value: function length() {
          return this.a.sub(this.b).length();
        }
      }, {
        key: "containsPoint",
        value: function containsPoint(point) {
          var eps = arguments.length > 1 && arguments[1] !== void 0 ? arguments[1] : 1e-12;
          return Math.abs(dist(this.a, this.b) - dist(point, this.a) - dist(point, this.b)) < eps;
        }
      }]);
      return Line32;
    })();
    var _default = Line3;
    exports["default"] = _default;
  }
});

// node_modules/vecks/lib/index.js
var require_lib = __commonJS({
  "node_modules/vecks/lib/index.js"(exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", {
      value: true
    });
    Object.defineProperty(exports, "V2", {
      enumerable: true,
      get: function get() {
        return _V["default"];
      }
    });
    Object.defineProperty(exports, "V3", {
      enumerable: true,
      get: function get() {
        return _V2["default"];
      }
    });
    Object.defineProperty(exports, "Box2", {
      enumerable: true,
      get: function get() {
        return _Box["default"];
      }
    });
    Object.defineProperty(exports, "Box3", {
      enumerable: true,
      get: function get() {
        return _Box2["default"];
      }
    });
    Object.defineProperty(exports, "Plane3", {
      enumerable: true,
      get: function get() {
        return _Plane["default"];
      }
    });
    Object.defineProperty(exports, "Quaternion", {
      enumerable: true,
      get: function get() {
        return _Quaternion["default"];
      }
    });
    Object.defineProperty(exports, "Line2", {
      enumerable: true,
      get: function get() {
        return _Line["default"];
      }
    });
    Object.defineProperty(exports, "Line3", {
      enumerable: true,
      get: function get() {
        return _Line2["default"];
      }
    });
    var _V = _interopRequireDefault(require_V2());
    var _V2 = _interopRequireDefault(require_V3());
    var _Box = _interopRequireDefault(require_Box2());
    var _Box2 = _interopRequireDefault(require_Box3());
    var _Plane = _interopRequireDefault(require_Plane3());
    var _Quaternion = _interopRequireDefault(require_Quaternion());
    var _Line = _interopRequireDefault(require_Line2());
    var _Line2 = _interopRequireDefault(require_Line3());
    function _interopRequireDefault(obj) {
      return obj && obj.__esModule ? obj : { "default": obj };
    }
  }
});

// node_modules/dxf/lib/util/colors.js
var require_colors = __commonJS({
  "node_modules/dxf/lib/util/colors.js"(exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", {
      value: true
    });
    exports["default"] = void 0;
    var _default = exports["default"] = [[0, 0, 0], [255, 0, 0], [255, 255, 0], [0, 255, 0], [0, 255, 255], [0, 0, 255], [255, 0, 255], [255, 255, 255], [65, 65, 65], [128, 128, 128], [255, 0, 0], [255, 170, 170], [189, 0, 0], [189, 126, 126], [129, 0, 0], [129, 86, 86], [104, 0, 0], [104, 69, 69], [79, 0, 0], [79, 53, 53], [255, 63, 0], [255, 191, 170], [189, 46, 0], [189, 141, 126], [129, 31, 0], [129, 96, 86], [104, 25, 0], [104, 78, 69], [79, 19, 0], [79, 59, 53], [255, 127, 0], [255, 212, 170], [189, 94, 0], [189, 157, 126], [129, 64, 0], [129, 107, 86], [104, 52, 0], [104, 86, 69], [79, 39, 0], [79, 66, 53], [255, 191, 0], [255, 234, 170], [189, 141, 0], [189, 173, 126], [129, 96, 0], [129, 118, 86], [104, 78, 0], [104, 95, 69], [79, 59, 0], [79, 73, 53], [255, 255, 0], [255, 255, 170], [189, 189, 0], [189, 189, 126], [129, 129, 0], [129, 129, 86], [104, 104, 0], [104, 104, 69], [79, 79, 0], [79, 79, 53], [191, 255, 0], [234, 255, 170], [141, 189, 0], [173, 189, 126], [96, 129, 0], [118, 129, 86], [78, 104, 0], [95, 104, 69], [59, 79, 0], [73, 79, 53], [127, 255, 0], [212, 255, 170], [94, 189, 0], [157, 189, 126], [64, 129, 0], [107, 129, 86], [52, 104, 0], [86, 104, 69], [39, 79, 0], [66, 79, 53], [63, 255, 0], [191, 255, 170], [46, 189, 0], [141, 189, 126], [31, 129, 0], [96, 129, 86], [25, 104, 0], [78, 104, 69], [19, 79, 0], [59, 79, 53], [0, 255, 0], [170, 255, 170], [0, 189, 0], [126, 189, 126], [0, 129, 0], [86, 129, 86], [0, 104, 0], [69, 104, 69], [0, 79, 0], [53, 79, 53], [0, 255, 63], [170, 255, 191], [0, 189, 46], [126, 189, 141], [0, 129, 31], [86, 129, 96], [0, 104, 25], [69, 104, 78], [0, 79, 19], [53, 79, 59], [0, 255, 127], [170, 255, 212], [0, 189, 94], [126, 189, 157], [0, 129, 64], [86, 129, 107], [0, 104, 52], [69, 104, 86], [0, 79, 39], [53, 79, 66], [0, 255, 191], [170, 255, 234], [0, 189, 141], [126, 189, 173], [0, 129, 96], [86, 129, 118], [0, 104, 78], [69, 104, 95], [0, 79, 59], [53, 79, 73], [0, 255, 255], [170, 255, 255], [0, 189, 189], [126, 189, 189], [0, 129, 129], [86, 129, 129], [0, 104, 104], [69, 104, 104], [0, 79, 79], [53, 79, 79], [0, 191, 255], [170, 234, 255], [0, 141, 189], [126, 173, 189], [0, 96, 129], [86, 118, 129], [0, 78, 104], [69, 95, 104], [0, 59, 79], [53, 73, 79], [0, 127, 255], [170, 212, 255], [0, 94, 189], [126, 157, 189], [0, 64, 129], [86, 107, 129], [0, 52, 104], [69, 86, 104], [0, 39, 79], [53, 66, 79], [0, 63, 255], [170, 191, 255], [0, 46, 189], [126, 141, 189], [0, 31, 129], [86, 96, 129], [0, 25, 104], [69, 78, 104], [0, 19, 79], [53, 59, 79], [0, 0, 255], [170, 170, 255], [0, 0, 189], [126, 126, 189], [0, 0, 129], [86, 86, 129], [0, 0, 104], [69, 69, 104], [0, 0, 79], [53, 53, 79], [63, 0, 255], [191, 170, 255], [46, 0, 189], [141, 126, 189], [31, 0, 129], [96, 86, 129], [25, 0, 104], [78, 69, 104], [19, 0, 79], [59, 53, 79], [127, 0, 255], [212, 170, 255], [94, 0, 189], [157, 126, 189], [64, 0, 129], [107, 86, 129], [52, 0, 104], [86, 69, 104], [39, 0, 79], [66, 53, 79], [191, 0, 255], [234, 170, 255], [141, 0, 189], [173, 126, 189], [96, 0, 129], [118, 86, 129], [78, 0, 104], [95, 69, 104], [59, 0, 79], [73, 53, 79], [255, 0, 255], [255, 170, 255], [189, 0, 189], [189, 126, 189], [129, 0, 129], [129, 86, 129], [104, 0, 104], [104, 69, 104], [79, 0, 79], [79, 53, 79], [255, 0, 191], [255, 170, 234], [189, 0, 141], [189, 126, 173], [129, 0, 96], [129, 86, 118], [104, 0, 78], [104, 69, 95], [79, 0, 59], [79, 53, 73], [255, 0, 127], [255, 170, 212], [189, 0, 94], [189, 126, 157], [129, 0, 64], [129, 86, 107], [104, 0, 52], [104, 69, 86], [79, 0, 39], [79, 53, 66], [255, 0, 63], [255, 170, 191], [189, 0, 46], [189, 126, 141], [129, 0, 31], [129, 86, 96], [104, 0, 25], [104, 69, 78], [79, 0, 19], [79, 53, 59], [51, 51, 51], [80, 80, 80], [105, 105, 105], [130, 130, 130], [190, 190, 190], [255, 255, 255]];
  }
});

// node_modules/dxf/lib/util/round10.js
var require_round10 = __commonJS({
  "node_modules/dxf/lib/util/round10.js"(exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", {
      value: true
    });
    exports["default"] = void 0;
    var _default = exports["default"] = function _default2(value, exp) {
      if (typeof exp === "undefined" || +exp === 0) {
        return Math.round(value);
      }
      value = +value;
      exp = +exp;
      if (isNaN(value) || !(typeof exp === "number" && exp % 1 === 0)) {
        return NaN;
      }
      value = value.toString().split("e");
      value = Math.round(+(value[0] + "e" + (value[1] ? +value[1] - exp : -exp)));
      value = value.toString().split("e");
      return +(value[0] + "e" + (value[1] ? +value[1] + exp : exp));
    };
  }
});

// node_modules/dxf/lib/util/bSpline.js
var require_bSpline = __commonJS({
  "node_modules/dxf/lib/util/bSpline.js"(exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", {
      value: true
    });
    exports["default"] = void 0;
    var _round = _interopRequireDefault(require_round10());
    function _interopRequireDefault(e) {
      return e && e.__esModule ? e : { "default": e };
    }
    var _default = exports["default"] = function _default2(t, degree, points, knots, weights) {
      var n = points.length;
      var d = points[0].length;
      if (t < 0 || t > 1) {
        throw new Error("t out of bounds [0,1]: " + t);
      }
      if (degree < 1) throw new Error("degree must be at least 1 (linear)");
      if (degree > n - 1) throw new Error("degree must be less than or equal to point count - 1");
      if (!weights) {
        weights = [];
        for (var i = 0; i < n; i++) {
          weights[i] = 1;
        }
      }
      if (!knots) {
        knots = [];
        for (var _i = 0; _i < n + degree + 1; _i++) {
          knots[_i] = _i;
        }
      } else {
        if (knots.length !== n + degree + 1) throw new Error("bad knot vector length");
      }
      var domain = [degree, knots.length - 1 - degree];
      var low = knots[domain[0]];
      var high = knots[domain[1]];
      t = t * (high - low) + low;
      t = Math.max(t, low);
      t = Math.min(t, high);
      var s;
      for (s = domain[0]; s < domain[1]; s++) {
        if (t >= knots[s] && t <= knots[s + 1]) {
          break;
        }
      }
      var v = [];
      for (var _i2 = 0; _i2 < n; _i2++) {
        v[_i2] = [];
        for (var j = 0; j < d; j++) {
          v[_i2][j] = points[_i2][j] * weights[_i2];
        }
        v[_i2][d] = weights[_i2];
      }
      var alpha;
      for (var l = 1; l <= degree + 1; l++) {
        for (var _i3 = s; _i3 > s - degree - 1 + l; _i3--) {
          alpha = (t - knots[_i3]) / (knots[_i3 + degree + 1 - l] - knots[_i3]);
          for (var _j = 0; _j < d + 1; _j++) {
            v[_i3][_j] = (1 - alpha) * v[_i3 - 1][_j] + alpha * v[_i3][_j];
          }
        }
      }
      var result = [];
      for (var _i4 = 0; _i4 < d; _i4++) {
        result[_i4] = (0, _round["default"])(v[s][_i4] / v[s][d], -9);
      }
      return result;
    };
  }
});

// node_modules/dxf/lib/util/createArcForLWPolyline.js
var require_createArcForLWPolyline = __commonJS({
  "node_modules/dxf/lib/util/createArcForLWPolyline.js"(exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", {
      value: true
    });
    exports["default"] = void 0;
    var _vecks = require_lib();
    var _default = exports["default"] = function _default2(from, to, bulge, resolution) {
      if (!resolution) {
        resolution = 5;
      }
      var theta;
      var a;
      var b;
      if (bulge < 0) {
        theta = Math.atan(-bulge) * 4;
        a = new _vecks.V2(from[0], from[1]);
        b = new _vecks.V2(to[0], to[1]);
      } else {
        theta = Math.atan(bulge) * 4;
        a = new _vecks.V2(to[0], to[1]);
        b = new _vecks.V2(from[0], from[1]);
      }
      var ab = b.sub(a);
      var lengthAB = ab.length();
      var c = a.add(ab.multiply(0.5));
      var lengthCD = Math.abs(lengthAB / 2 / Math.tan(theta / 2));
      var normAB = ab.norm();
      var d;
      if (theta < Math.PI) {
        var normDC = new _vecks.V2(normAB.x * Math.cos(Math.PI / 2) - normAB.y * Math.sin(Math.PI / 2), normAB.y * Math.cos(Math.PI / 2) + normAB.x * Math.sin(Math.PI / 2));
        d = c.add(normDC.multiply(-lengthCD));
      } else {
        var normCD = new _vecks.V2(normAB.x * Math.cos(Math.PI / 2) - normAB.y * Math.sin(Math.PI / 2), normAB.y * Math.cos(Math.PI / 2) + normAB.x * Math.sin(Math.PI / 2));
        d = c.add(normCD.multiply(lengthCD));
      }
      var startAngle = Math.atan2(b.y - d.y, b.x - d.x) / Math.PI * 180;
      var endAngle = Math.atan2(a.y - d.y, a.x - d.x) / Math.PI * 180;
      if (endAngle < startAngle) {
        endAngle += 360;
      }
      var r = b.sub(d).length();
      var startInter = Math.floor(startAngle / resolution) * resolution + resolution;
      var endInter = Math.ceil(endAngle / resolution) * resolution - resolution;
      var points = [];
      for (var i = startInter; i <= endInter; i += resolution) {
        points.push(d.add(new _vecks.V2(Math.cos(i / 180 * Math.PI) * r, Math.sin(i / 180 * Math.PI) * r)));
      }
      if (bulge < 0) {
        points.reverse();
      }
      return points.map(function(p) {
        return [p.x, p.y];
      });
    };
  }
});

// node_modules/dxf/lib/entityToPolyline.js
var require_entityToPolyline = __commonJS({
  "node_modules/dxf/lib/entityToPolyline.js"(exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", {
      value: true
    });
    exports.polyfaceOutline = exports.interpolateBSpline = exports["default"] = void 0;
    var _bSpline = _interopRequireDefault(require_bSpline());
    var _logger = _interopRequireDefault(require_logger());
    var _createArcForLWPolyline = _interopRequireDefault(require_createArcForLWPolyline());
    function _interopRequireDefault(e) {
      return e && e.__esModule ? e : { "default": e };
    }
    function _toConsumableArray(r) {
      return _arrayWithoutHoles(r) || _iterableToArray(r) || _unsupportedIterableToArray(r) || _nonIterableSpread();
    }
    function _nonIterableSpread() {
      throw new TypeError("Invalid attempt to spread non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method.");
    }
    function _iterableToArray(r) {
      if ("undefined" != typeof Symbol && null != r[Symbol.iterator] || null != r["@@iterator"]) return Array.from(r);
    }
    function _arrayWithoutHoles(r) {
      if (Array.isArray(r)) return _arrayLikeToArray(r);
    }
    function _createForOfIteratorHelper(r, e) {
      var t = "undefined" != typeof Symbol && r[Symbol.iterator] || r["@@iterator"];
      if (!t) {
        if (Array.isArray(r) || (t = _unsupportedIterableToArray(r)) || e && r && "number" == typeof r.length) {
          t && (r = t);
          var _n = 0, F = function F2() {
          };
          return { s: F, n: function n() {
            return _n >= r.length ? { done: true } : { done: false, value: r[_n++] };
          }, e: function e2(r2) {
            throw r2;
          }, f: F };
        }
        throw new TypeError("Invalid attempt to iterate non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method.");
      }
      var o, a = true, u = false;
      return { s: function s() {
        t = t.call(r);
      }, n: function n() {
        var r2 = t.next();
        return a = r2.done, r2;
      }, e: function e2(r2) {
        u = true, o = r2;
      }, f: function f() {
        try {
          a || null == t["return"] || t["return"]();
        } finally {
          if (u) throw o;
        }
      } };
    }
    function _unsupportedIterableToArray(r, a) {
      if (r) {
        if ("string" == typeof r) return _arrayLikeToArray(r, a);
        var t = {}.toString.call(r).slice(8, -1);
        return "Object" === t && r.constructor && (t = r.constructor.name), "Map" === t || "Set" === t ? Array.from(r) : "Arguments" === t || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(t) ? _arrayLikeToArray(r, a) : void 0;
      }
    }
    function _arrayLikeToArray(r, a) {
      (null == a || a > r.length) && (a = r.length);
      for (var e = 0, n = Array(a); e < a; e++) n[e] = r[e];
      return n;
    }
    var rotate = function rotate2(points, angle) {
      return points.map(function(p) {
        return [p[0] * Math.cos(angle) - p[1] * Math.sin(angle), p[1] * Math.cos(angle) + p[0] * Math.sin(angle)];
      });
    };
    var interpolateEllipse = function interpolateEllipse2(cx, cy, rx, ry, start, end, rotationAngle) {
      if (end < start) {
        end += Math.PI * 2;
      }
      var points = [];
      var dTheta = Math.PI * 2 / 72;
      var EPS = 1e-6;
      for (var theta = start; theta < end - EPS; theta += dTheta) {
        points.push([Math.cos(theta) * rx, Math.sin(theta) * ry]);
      }
      points.push([Math.cos(end) * rx, Math.sin(end) * ry]);
      if (rotationAngle) {
        points = rotate(points, rotationAngle);
      }
      points = points.map(function(p) {
        return [cx + p[0], cy + p[1]];
      });
      return points;
    };
    var interpolateBSpline = exports.interpolateBSpline = function interpolateBSpline2(controlPoints, degree, knots, interpolationsPerSplineSegment, weights) {
      var polyline = [];
      var controlPointsForLib = controlPoints.map(function(p2) {
        return [p2.x, p2.y];
      });
      var segmentTs = [knots[degree]];
      var domain = [knots[degree], knots[knots.length - 1 - degree]];
      for (var k = degree + 1; k < knots.length - degree; ++k) {
        if (segmentTs[segmentTs.length - 1] !== knots[k]) {
          segmentTs.push(knots[k]);
        }
      }
      interpolationsPerSplineSegment = interpolationsPerSplineSegment || 25;
      for (var i = 1; i < segmentTs.length; ++i) {
        var uMin = segmentTs[i - 1];
        var uMax = segmentTs[i];
        for (var _k = 0; _k <= interpolationsPerSplineSegment; ++_k) {
          var u = _k / interpolationsPerSplineSegment * (uMax - uMin) + uMin;
          var t = (u - domain[0]) / (domain[1] - domain[0]);
          t = Math.max(t, 0);
          t = Math.min(t, 1);
          var p = (0, _bSpline["default"])(t, degree, controlPointsForLib, knots, weights);
          polyline.push(p);
        }
      }
      return polyline;
    };
    var polyfaceOutline = exports.polyfaceOutline = function polyfaceOutline2(entity) {
      var vertices = [];
      var faces = [];
      var _iterator = _createForOfIteratorHelper(entity.vertices), _step;
      try {
        for (_iterator.s(); !(_step = _iterator.n()).done; ) {
          var v = _step.value;
          if (v.faces) {
            var _face = {
              indices: [],
              hiddens: []
            };
            var _iterator3 = _createForOfIteratorHelper(v.faces), _step3;
            try {
              for (_iterator3.s(); !(_step3 = _iterator3.n()).done; ) {
                var i = _step3.value;
                if (i === 0) {
                  break;
                }
                _face.indices.push(i < 0 ? -i - 1 : i - 1);
                _face.hiddens.push(i < 0);
              }
            } catch (err) {
              _iterator3.e(err);
            } finally {
              _iterator3.f();
            }
            if ([3, 4].includes(_face.indices.length)) faces.push(_face);
          } else {
            vertices.push({
              x: v.x,
              y: v.y
            });
          }
        }
      } catch (err) {
        _iterator.e(err);
      } finally {
        _iterator.f();
      }
      var polylines = [];
      var segment = function segment2(a2, b2) {
        for (var _i = 0, _polylines = polylines; _i < _polylines.length; _i++) {
          var prev = _polylines[_i];
          if (prev.slice(-1)[0] === a2) {
            return prev.push(b2);
          }
        }
        polylines.push([a2, b2]);
      };
      for (var _i2 = 0, _faces = faces; _i2 < _faces.length; _i2++) {
        var face = _faces[_i2];
        for (var beg = 0; beg < face.indices.length; beg++) {
          if (face.hiddens[beg]) {
            continue;
          }
          var end = (beg + 1) % face.indices.length;
          segment(face.indices[beg], face.indices[end]);
        }
      }
      for (var _i3 = 0, _polylines2 = polylines; _i3 < _polylines2.length; _i3++) {
        var a = _polylines2[_i3];
        var _iterator2 = _createForOfIteratorHelper(polylines), _step2;
        try {
          for (_iterator2.s(); !(_step2 = _iterator2.n()).done; ) {
            var b = _step2.value;
            if (a !== b && a[0] === b.slice(-1)[0]) {
              b.push.apply(b, _toConsumableArray(a.slice(1)));
              a.splice(0, a.length);
              break;
            }
          }
        } catch (err) {
          _iterator2.e(err);
        } finally {
          _iterator2.f();
        }
      }
      return polylines.filter(function(l) {
        return l.length;
      }).map(function(l) {
        return l.map(function(i2) {
          return vertices[i2];
        }).map(function(v2) {
          return [v2.x, v2.y];
        });
      });
    };
    var _default = exports["default"] = function _default2(entity, options) {
      options = options || {};
      var polyline;
      if (entity.type === "LINE") {
        polyline = [[entity.start.x, entity.start.y], [entity.end.x, entity.end.y]];
      }
      if (entity.type === "LWPOLYLINE" || entity.type === "POLYLINE") {
        polyline = [];
        if (entity.polyfaceMesh) {
          var _polyline;
          (_polyline = polyline).push.apply(_polyline, _toConsumableArray(polyfaceOutline(entity)[0]));
        } else if (entity.polygonMesh) {
        } else if (entity.vertices.length) {
          if (entity.closed) {
            entity.vertices = entity.vertices.concat(entity.vertices[0]);
          }
          for (var i = 0, il = entity.vertices.length; i < il - 1; ++i) {
            var from = [entity.vertices[i].x, entity.vertices[i].y];
            var to = [entity.vertices[i + 1].x, entity.vertices[i + 1].y];
            polyline.push(from);
            if (entity.vertices[i].bulge) {
              polyline = polyline.concat((0, _createArcForLWPolyline["default"])(from, to, entity.vertices[i].bulge));
            }
            if (i === il - 2) {
              polyline.push(to);
            }
          }
        } else {
          _logger["default"].warn("Polyline entity with no vertices");
        }
      }
      if (entity.type === "CIRCLE") {
        polyline = interpolateEllipse(entity.x, entity.y, entity.r, entity.r, 0, Math.PI * 2);
        if (entity.extrusionZ === -1) {
          polyline = polyline.map(function(p) {
            return [-p[0], p[1]];
          });
        }
      }
      if (entity.type === "ELLIPSE") {
        var rx = Math.sqrt(entity.majorX * entity.majorX + entity.majorY * entity.majorY);
        var ry = entity.axisRatio * rx;
        var majorAxisRotation = -Math.atan2(-entity.majorY, entity.majorX);
        polyline = interpolateEllipse(entity.x, entity.y, rx, ry, entity.startAngle, entity.endAngle, majorAxisRotation);
        if (entity.extrusionZ === -1) {
          polyline = polyline.map(function(p) {
            return [-p[0], p[1]];
          });
        }
      }
      if (entity.type === "ARC") {
        polyline = interpolateEllipse(entity.x, entity.y, entity.r, entity.r, entity.startAngle, entity.endAngle, void 0, false);
        if (entity.extrusionZ === -1) {
          polyline = polyline.map(function(p) {
            return [-p[0], p[1]];
          });
        }
      }
      if (entity.type === "SPLINE") {
        polyline = interpolateBSpline(entity.controlPoints, entity.degree, entity.knots, options.interpolationsPerSplineSegment, entity.weights);
      }
      if (!polyline) {
        _logger["default"].warn("unsupported entity for converting to polyline:", entity.type);
        return [];
      }
      return polyline;
    };
  }
});

// node_modules/dxf/lib/applyTransforms.js
var require_applyTransforms = __commonJS({
  "node_modules/dxf/lib/applyTransforms.js"(exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", {
      value: true
    });
    exports["default"] = void 0;
    var _default = exports["default"] = function _default2(polyline, transforms) {
      transforms.forEach(function(transform) {
        polyline = polyline.map(function(p) {
          var p2 = [p[0], p[1]];
          if (transform.scaleX) {
            p2[0] = p2[0] * transform.scaleX;
          }
          if (transform.scaleY) {
            p2[1] = p2[1] * transform.scaleY;
          }
          if (transform.rotation) {
            var angle = transform.rotation / 180 * Math.PI;
            p2 = [p2[0] * Math.cos(angle) - p2[1] * Math.sin(angle), p2[1] * Math.cos(angle) + p2[0] * Math.sin(angle)];
          }
          if (transform.x) {
            p2[0] = p2[0] + transform.x;
          }
          if (transform.y) {
            p2[1] = p2[1] + transform.y;
          }
          if (transform.extrusionZ === -1) {
            p2[0] = -p2[0];
          }
          return p2;
        });
      });
      return polyline;
    };
  }
});

// node_modules/dxf/lib/toPolylines.js
var require_toPolylines = __commonJS({
  "node_modules/dxf/lib/toPolylines.js"(exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", {
      value: true
    });
    exports["default"] = void 0;
    var _vecks = require_lib();
    var _colors = _interopRequireDefault(require_colors());
    var _denormalise = _interopRequireDefault(require_denormalise());
    var _entityToPolyline = _interopRequireDefault(require_entityToPolyline());
    var _applyTransforms = _interopRequireDefault(require_applyTransforms());
    var _logger = _interopRequireDefault(require_logger());
    function _interopRequireDefault(e) {
      return e && e.__esModule ? e : { "default": e };
    }
    var _default = exports["default"] = function _default2(parsed) {
      var entities = (0, _denormalise["default"])(parsed);
      var polylines = entities.map(function(entity) {
        var layerTable = parsed.tables.layers[entity.layer];
        var colorNumber = 0;
        if ("colorNumber" in entity) {
          colorNumber = entity.colorNumber;
        } else if (layerTable) {
          colorNumber = layerTable.colorNumber;
        }
        if (_colors["default"][colorNumber] === void 0) {
          _logger["default"].warn("Color index", colorNumber, "invalid, defaulting to black");
          colorNumber = 0;
        }
        return {
          rgb: _colors["default"][colorNumber],
          layer: layerTable,
          vertices: (0, _applyTransforms["default"])((0, _entityToPolyline["default"])(entity), entity.transforms)
        };
      });
      var bbox = new _vecks.Box2();
      polylines.forEach(function(polyline) {
        polyline.vertices.forEach(function(vertex) {
          bbox.expandByPoint({
            x: vertex[0],
            y: vertex[1]
          });
        });
      });
      return {
        bbox,
        polylines
      };
    };
  }
});

// node_modules/dxf/lib/getRGBForEntity.js
var require_getRGBForEntity = __commonJS({
  "node_modules/dxf/lib/getRGBForEntity.js"(exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", {
      value: true
    });
    exports["default"] = void 0;
    var _colors = _interopRequireDefault(require_colors());
    var _logger = _interopRequireDefault(require_logger());
    function _interopRequireDefault(e) {
      return e && e.__esModule ? e : { "default": e };
    }
    var _default = exports["default"] = function _default2(layers, entity) {
      var layerTable = layers[entity.layer];
      if (layerTable) {
        var colorDefinedInEntity = "colorNumber" in entity && entity.colorNumber !== 256;
        var colorNumber = colorDefinedInEntity ? entity.colorNumber : layerTable.colorNumber;
        var rgb = _colors["default"][colorNumber];
        if (rgb) {
          return rgb;
        } else {
          _logger["default"].warn("Color index", colorNumber, "invalid, defaulting to black");
          return [0, 0, 0];
        }
      } else {
        _logger["default"].warn("no layer table for layer:" + entity.layer);
        return [0, 0, 0];
      }
    };
  }
});

// node_modules/dxf/lib/util/rotate.js
var require_rotate = __commonJS({
  "node_modules/dxf/lib/util/rotate.js"(exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", {
      value: true
    });
    exports["default"] = void 0;
    var _default = exports["default"] = function _default2(p, angle) {
      return {
        x: p.x * Math.cos(angle) - p.y * Math.sin(angle),
        y: p.y * Math.cos(angle) + p.x * Math.sin(angle)
      };
    };
  }
});

// node_modules/dxf/lib/util/rgbToColorAttribute.js
var require_rgbToColorAttribute = __commonJS({
  "node_modules/dxf/lib/util/rgbToColorAttribute.js"(exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", {
      value: true
    });
    exports["default"] = void 0;
    var _default = exports["default"] = function _default2(rgb) {
      if (rgb[0] === 255 && rgb[1] === 255 && rgb[2] === 255) {
        return "rgb(0, 0, 0)";
      } else {
        return "rgb(".concat(rgb[0], ", ").concat(rgb[1], ", ").concat(rgb[2], ")");
      }
    };
  }
});

// node_modules/dxf/lib/util/insertKnot.js
var require_insertKnot = __commonJS({
  "node_modules/dxf/lib/util/insertKnot.js"(exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", {
      value: true
    });
    exports["default"] = void 0;
    var _default = exports["default"] = function _default2(k, controlPoints, knots, newKnot) {
      var x = knots;
      var b = controlPoints;
      var n = controlPoints.length;
      var i = 0;
      var foundIndex = false;
      for (var j = 0; j < n + k; j++) {
        if (newKnot > x[j] && newKnot <= x[j + 1]) {
          i = j;
          foundIndex = true;
          break;
        }
      }
      if (!foundIndex) {
        throw new Error("invalid new knot");
      }
      var xHat = [];
      for (var _j = 0; _j < n + k + 1; _j++) {
        if (_j <= i) {
          xHat[_j] = x[_j];
        } else if (_j === i + 1) {
          xHat[_j] = newKnot;
        } else {
          xHat[_j] = x[_j - 1];
        }
      }
      var alpha;
      var bHat = [];
      for (var _j2 = 0; _j2 < n + 1; _j2++) {
        if (_j2 <= i - k + 1) {
          alpha = 1;
        } else if (i - k + 2 <= _j2 && _j2 <= i) {
          if (x[_j2 + k - 1] - x[_j2] === 0) {
            alpha = 0;
          } else {
            alpha = (newKnot - x[_j2]) / (x[_j2 + k - 1] - x[_j2]);
          }
        } else {
          alpha = 0;
        }
        if (alpha === 0) {
          bHat[_j2] = b[_j2 - 1];
        } else if (alpha === 1) {
          bHat[_j2] = b[_j2];
        } else {
          bHat[_j2] = {
            x: (1 - alpha) * b[_j2 - 1].x + alpha * b[_j2].x,
            y: (1 - alpha) * b[_j2 - 1].y + alpha * b[_j2].y
          };
        }
      }
      return {
        controlPoints: bHat,
        knots: xHat
      };
    };
  }
});

// node_modules/dxf/lib/util/toPiecewiseBezier.js
var require_toPiecewiseBezier = __commonJS({
  "node_modules/dxf/lib/util/toPiecewiseBezier.js"(exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", {
      value: true
    });
    exports.multiplicity = exports["default"] = exports.computeInsertions = exports.checkPinned = void 0;
    var _insertKnot = _interopRequireDefault(require_insertKnot());
    function _interopRequireDefault(e) {
      return e && e.__esModule ? e : { "default": e };
    }
    var checkPinned = exports.checkPinned = function checkPinned2(k, knots) {
      for (var i = 1; i < k; ++i) {
        if (knots[i] !== knots[0]) {
          throw Error("not pinned. order: ".concat(k, " knots: ").concat(knots));
        }
      }
      for (var _i = knots.length - 2; _i > knots.length - k - 1; --_i) {
        if (knots[_i] !== knots[knots.length - 1]) {
          throw Error("not pinned. order: ".concat(k, " knots: ").concat(knots));
        }
      }
    };
    var multiplicity = exports.multiplicity = function multiplicity2(knots, index) {
      var m = 1;
      for (var i = index + 1; i < knots.length; ++i) {
        if (knots[i] === knots[index]) {
          ++m;
        } else {
          break;
        }
      }
      return m;
    };
    var computeInsertions = exports.computeInsertions = function computeInsertions2(k, knots) {
      var inserts = [];
      var i = k;
      while (i < knots.length - k) {
        var knot = knots[i];
        var m = multiplicity(knots, i);
        for (var j = 0; j < k - m - 1; ++j) {
          inserts.push(knot);
        }
        i = i + m;
      }
      return inserts;
    };
    var _default = exports["default"] = function _default2(k, controlPoints, knots) {
      checkPinned(k, knots);
      var insertions = computeInsertions(k, knots);
      return insertions.reduce(function(acc, tNew) {
        return (0, _insertKnot["default"])(k, acc.controlPoints, acc.knots, tNew);
      }, {
        controlPoints,
        knots
      });
    };
  }
});

// node_modules/dxf/lib/util/transformBoundingBoxAndElement.js
var require_transformBoundingBoxAndElement = __commonJS({
  "node_modules/dxf/lib/util/transformBoundingBoxAndElement.js"(exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", {
      value: true
    });
    exports["default"] = void 0;
    var _vecks = require_lib();
    function _slicedToArray(r, e) {
      return _arrayWithHoles(r) || _iterableToArrayLimit(r, e) || _unsupportedIterableToArray(r, e) || _nonIterableRest();
    }
    function _nonIterableRest() {
      throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method.");
    }
    function _unsupportedIterableToArray(r, a) {
      if (r) {
        if ("string" == typeof r) return _arrayLikeToArray(r, a);
        var t = {}.toString.call(r).slice(8, -1);
        return "Object" === t && r.constructor && (t = r.constructor.name), "Map" === t || "Set" === t ? Array.from(r) : "Arguments" === t || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(t) ? _arrayLikeToArray(r, a) : void 0;
      }
    }
    function _arrayLikeToArray(r, a) {
      (null == a || a > r.length) && (a = r.length);
      for (var e = 0, n = Array(a); e < a; e++) n[e] = r[e];
      return n;
    }
    function _iterableToArrayLimit(r, l) {
      var t = null == r ? null : "undefined" != typeof Symbol && r[Symbol.iterator] || r["@@iterator"];
      if (null != t) {
        var e, n, i, u, a = [], f = true, o = false;
        try {
          if (i = (t = t.call(r)).next, 0 === l) {
            if (Object(t) !== t) return;
            f = false;
          } else for (; !(f = (e = i.call(t)).done) && (a.push(e.value), a.length !== l); f = true) ;
        } catch (r2) {
          o = true, n = r2;
        } finally {
          try {
            if (!f && null != t["return"] && (u = t["return"](), Object(u) !== u)) return;
          } finally {
            if (o) throw n;
          }
        }
        return a;
      }
    }
    function _arrayWithHoles(r) {
      if (Array.isArray(r)) return r;
    }
    var _default = exports["default"] = function _default2(bbox, element, transforms) {
      var transformedElement = "";
      var matrices = transforms.map(function(transform) {
        var tx = transform.x || 0;
        var ty = transform.y || 0;
        var sx = transform.scaleX || 1;
        var sy = transform.scaleY || 1;
        var angle = (transform.rotation || 0) / 180 * Math.PI;
        var cos = Math.cos, sin = Math.sin;
        var a, b, c, d, e, f;
        if (transform.extrusionZ === -1) {
          a = -sx * cos(angle);
          b = sx * sin(angle);
          c = sy * sin(angle);
          d = sy * cos(angle);
          e = -tx;
          f = ty;
        } else {
          a = sx * cos(angle);
          b = sx * sin(angle);
          c = -sy * sin(angle);
          d = sy * cos(angle);
          e = tx;
          f = ty;
        }
        return [a, b, c, d, e, f];
      });
      var transformedBBox = new _vecks.Box2();
      if (bbox.valid) {
        var bboxPoints = [{
          x: bbox.min.x,
          y: bbox.min.y
        }, {
          x: bbox.max.x,
          y: bbox.min.y
        }, {
          x: bbox.max.x,
          y: bbox.max.y
        }, {
          x: bbox.min.x,
          y: bbox.max.y
        }];
        matrices.forEach(function(_ref) {
          var _ref2 = _slicedToArray(_ref, 6), a = _ref2[0], b = _ref2[1], c = _ref2[2], d = _ref2[3], e = _ref2[4], f = _ref2[5];
          bboxPoints = bboxPoints.map(function(point) {
            return {
              x: point.x * a + point.y * c + e,
              y: point.x * b + point.y * d + f
            };
          });
        });
        transformedBBox = bboxPoints.reduce(function(acc, point) {
          return acc.expandByPoint(point);
        }, new _vecks.Box2());
      }
      matrices.reverse();
      matrices.forEach(function(_ref3) {
        var _ref4 = _slicedToArray(_ref3, 6), a = _ref4[0], b = _ref4[1], c = _ref4[2], d = _ref4[3], e = _ref4[4], f = _ref4[5];
        transformedElement += '<g transform="matrix('.concat(a, " ").concat(b, " ").concat(c, " ").concat(d, " ").concat(e, " ").concat(f, ')">');
      });
      transformedElement += element;
      matrices.forEach(function(transform) {
        transformedElement += "</g>";
      });
      return {
        bbox: transformedBBox,
        element: transformedElement
      };
    };
  }
});

// node_modules/dxf/lib/toSVG.js
var require_toSVG = __commonJS({
  "node_modules/dxf/lib/toSVG.js"(exports) {
    "use strict";
    function _typeof(o) {
      "@babel/helpers - typeof";
      return _typeof = "function" == typeof Symbol && "symbol" == typeof Symbol.iterator ? function(o2) {
        return typeof o2;
      } : function(o2) {
        return o2 && "function" == typeof Symbol && o2.constructor === Symbol && o2 !== Symbol.prototype ? "symbol" : typeof o2;
      }, _typeof(o);
    }
    Object.defineProperty(exports, "__esModule", {
      value: true
    });
    exports.piecewiseToPaths = exports["default"] = void 0;
    var _vecks = require_lib();
    var _entityToPolyline = _interopRequireDefault(require_entityToPolyline());
    var _denormalise = _interopRequireDefault(require_denormalise());
    var _getRGBForEntity = _interopRequireDefault(require_getRGBForEntity());
    var _logger = _interopRequireDefault(require_logger());
    var _rotate = _interopRequireDefault(require_rotate());
    var _rgbToColorAttribute = _interopRequireDefault(require_rgbToColorAttribute());
    var _toPiecewiseBezier = _interopRequireWildcard(require_toPiecewiseBezier());
    var _transformBoundingBoxAndElement = _interopRequireDefault(require_transformBoundingBoxAndElement());
    function _getRequireWildcardCache(e) {
      if ("function" != typeof WeakMap) return null;
      var r = /* @__PURE__ */ new WeakMap(), t = /* @__PURE__ */ new WeakMap();
      return (_getRequireWildcardCache = function _getRequireWildcardCache2(e2) {
        return e2 ? t : r;
      })(e);
    }
    function _interopRequireWildcard(e, r) {
      if (!r && e && e.__esModule) return e;
      if (null === e || "object" != _typeof(e) && "function" != typeof e) return { "default": e };
      var t = _getRequireWildcardCache(r);
      if (t && t.has(e)) return t.get(e);
      var n = { __proto__: null }, a = Object.defineProperty && Object.getOwnPropertyDescriptor;
      for (var u in e) if ("default" !== u && {}.hasOwnProperty.call(e, u)) {
        var i = a ? Object.getOwnPropertyDescriptor(e, u) : null;
        i && (i.get || i.set) ? Object.defineProperty(n, u, i) : n[u] = e[u];
      }
      return n["default"] = e, t && t.set(e, n), n;
    }
    function _interopRequireDefault(e) {
      return e && e.__esModule ? e : { "default": e };
    }
    function _slicedToArray(r, e) {
      return _arrayWithHoles(r) || _iterableToArrayLimit(r, e) || _unsupportedIterableToArray(r, e) || _nonIterableRest();
    }
    function _nonIterableRest() {
      throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method.");
    }
    function _unsupportedIterableToArray(r, a) {
      if (r) {
        if ("string" == typeof r) return _arrayLikeToArray(r, a);
        var t = {}.toString.call(r).slice(8, -1);
        return "Object" === t && r.constructor && (t = r.constructor.name), "Map" === t || "Set" === t ? Array.from(r) : "Arguments" === t || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(t) ? _arrayLikeToArray(r, a) : void 0;
      }
    }
    function _arrayLikeToArray(r, a) {
      (null == a || a > r.length) && (a = r.length);
      for (var e = 0, n = Array(a); e < a; e++) n[e] = r[e];
      return n;
    }
    function _iterableToArrayLimit(r, l) {
      var t = null == r ? null : "undefined" != typeof Symbol && r[Symbol.iterator] || r["@@iterator"];
      if (null != t) {
        var e, n, i, u, a = [], f = true, o = false;
        try {
          if (i = (t = t.call(r)).next, 0 === l) {
            if (Object(t) !== t) return;
            f = false;
          } else for (; !(f = (e = i.call(t)).done) && (a.push(e.value), a.length !== l); f = true) ;
        } catch (r2) {
          o = true, n = r2;
        } finally {
          try {
            if (!f && null != t["return"] && (u = t["return"](), Object(u) !== u)) return;
          } finally {
            if (o) throw n;
          }
        }
        return a;
      }
    }
    function _arrayWithHoles(r) {
      if (Array.isArray(r)) return r;
    }
    var addFlipXIfApplicable = function addFlipXIfApplicable2(entity, _ref) {
      var bbox = _ref.bbox, element = _ref.element;
      if (entity.extrusionZ === -1) {
        return {
          bbox: new _vecks.Box2().expandByPoint({
            x: -bbox.min.x,
            y: bbox.min.y
          }).expandByPoint({
            x: -bbox.max.x,
            y: bbox.max.y
          }),
          element: '<g transform="matrix(-1 0 0 1 0 0)">\n        '.concat(element, "\n      </g>")
        };
      } else {
        return {
          bbox,
          element
        };
      }
    };
    var polyline = function polyline2(entity) {
      var vertices = (0, _entityToPolyline["default"])(entity);
      var bbox = vertices.reduce(function(acc, _ref2) {
        var _ref3 = _slicedToArray(_ref2, 2), x = _ref3[0], y = _ref3[1];
        return acc.expandByPoint({
          x,
          y
        });
      }, new _vecks.Box2());
      var d = vertices.reduce(function(acc, point, i) {
        acc += i === 0 ? "M" : "L";
        acc += point[0] + "," + point[1];
        return acc;
      }, "");
      return (0, _transformBoundingBoxAndElement["default"])(bbox, '<path d="'.concat(d, '" />'), entity.transforms);
    };
    var lwpolyline = function lwpolyline2(entity) {
      var vertices = (0, _entityToPolyline["default"])(entity);
      var bbox0 = vertices.reduce(function(acc, _ref4) {
        var _ref5 = _slicedToArray(_ref4, 2), x = _ref5[0], y = _ref5[1];
        return acc.expandByPoint({
          x,
          y
        });
      }, new _vecks.Box2());
      var d = vertices.reduce(function(acc, point, i) {
        acc += i === 0 ? "M" : "L";
        acc += point[0] + "," + point[1];
        return acc;
      }, "");
      var element0 = '<path d="'.concat(d, '" />');
      var _addFlipXIfApplicable = addFlipXIfApplicable(entity, {
        bbox: bbox0,
        element: element0
      }), bbox = _addFlipXIfApplicable.bbox, element = _addFlipXIfApplicable.element;
      return (0, _transformBoundingBoxAndElement["default"])(bbox, element, entity.transforms);
    };
    var circle = function circle2(entity) {
      var bbox0 = new _vecks.Box2().expandByPoint({
        x: entity.x + entity.r,
        y: entity.y + entity.r
      }).expandByPoint({
        x: entity.x - entity.r,
        y: entity.y - entity.r
      });
      var element0 = '<circle cx="'.concat(entity.x, '" cy="').concat(entity.y, '" r="').concat(entity.r, '" />');
      var _addFlipXIfApplicable2 = addFlipXIfApplicable(entity, {
        bbox: bbox0,
        element: element0
      }), bbox = _addFlipXIfApplicable2.bbox, element = _addFlipXIfApplicable2.element;
      return (0, _transformBoundingBoxAndElement["default"])(bbox, element, entity.transforms);
    };
    var ellipseOrArc = function ellipseOrArc2(cx, cy, majorX, majorY, axisRatio, startAngle, endAngle, flipX) {
      var rx = Math.sqrt(majorX * majorX + majorY * majorY);
      var ry = axisRatio * rx;
      var rotationAngle = -Math.atan2(-majorY, majorX);
      var bbox = bboxEllipseOrArc(cx, cy, majorX, majorY, axisRatio, startAngle, endAngle, flipX);
      if (Math.abs(startAngle - endAngle) < 1e-9 || Math.abs(startAngle - endAngle + Math.PI * 2) < 1e-9) {
        var element = '<g transform="rotate('.concat(rotationAngle / Math.PI * 180, " ").concat(cx, ", ").concat(cy, ')">\n      <ellipse cx="').concat(cx, '" cy="').concat(cy, '" rx="').concat(rx, '" ry="').concat(ry, '" />\n    </g>');
        return {
          bbox,
          element
        };
      } else {
        var startOffset = (0, _rotate["default"])({
          x: Math.cos(startAngle) * rx,
          y: Math.sin(startAngle) * ry
        }, rotationAngle);
        var startPoint = {
          x: cx + startOffset.x,
          y: cy + startOffset.y
        };
        var endOffset = (0, _rotate["default"])({
          x: Math.cos(endAngle) * rx,
          y: Math.sin(endAngle) * ry
        }, rotationAngle);
        var endPoint = {
          x: cx + endOffset.x,
          y: cy + endOffset.y
        };
        var adjustedEndAngle = endAngle < startAngle ? endAngle + Math.PI * 2 : endAngle;
        var largeArcFlag = adjustedEndAngle - startAngle < Math.PI ? 0 : 1;
        var d = "M ".concat(startPoint.x, " ").concat(startPoint.y, " A ").concat(rx, " ").concat(ry, " ").concat(rotationAngle / Math.PI * 180, " ").concat(largeArcFlag, " 1 ").concat(endPoint.x, " ").concat(endPoint.y);
        var _element = '<path d="'.concat(d, '" />');
        return {
          bbox,
          element: _element
        };
      }
    };
    var bboxEllipseOrArc = function bboxEllipseOrArc2(cx, cy, majorX, majorY, axisRatio, startAngle, endAngle, flipX) {
      while (startAngle < 0) startAngle += Math.PI * 2;
      while (endAngle <= startAngle) endAngle += Math.PI * 2;
      var angles = [];
      if (Math.abs(majorX) < 1e-12 || Math.abs(majorY) < 1e-12) {
        for (var i = 0; i < 4; i++) {
          angles.push(i / 2 * Math.PI);
        }
      } else {
        angles[0] = Math.atan(-majorY * axisRatio / majorX) - Math.PI;
        angles[1] = Math.atan(majorX * axisRatio / majorY) - Math.PI;
        angles[2] = angles[0] - Math.PI;
        angles[3] = angles[1] - Math.PI;
      }
      for (var _i = 4; _i >= 0; _i--) {
        while (angles[_i] < startAngle) angles[_i] += Math.PI * 2;
        if (angles[_i] > endAngle) {
          angles.splice(_i, 1);
        }
      }
      angles.push(startAngle);
      angles.push(endAngle);
      var pts = angles.map(function(a) {
        return {
          x: Math.cos(a),
          y: Math.sin(a)
        };
      });
      var M = [[majorX, -majorY * axisRatio], [majorY, majorX * axisRatio]];
      var rotatedPts = pts.map(function(p) {
        return {
          x: p.x * M[0][0] + p.y * M[0][1] + cx,
          y: p.x * M[1][0] + p.y * M[1][1] + cy
        };
      });
      var bbox = rotatedPts.reduce(function(acc, p) {
        acc.expandByPoint(p);
        return acc;
      }, new _vecks.Box2());
      return bbox;
    };
    var ellipse = function ellipse2(entity) {
      var _ellipseOrArc = ellipseOrArc(entity.x, entity.y, entity.majorX, entity.majorY, entity.axisRatio, entity.startAngle, entity.endAngle), bbox0 = _ellipseOrArc.bbox, element0 = _ellipseOrArc.element;
      var _addFlipXIfApplicable3 = addFlipXIfApplicable(entity, {
        bbox: bbox0,
        element: element0
      }), bbox = _addFlipXIfApplicable3.bbox, element = _addFlipXIfApplicable3.element;
      return (0, _transformBoundingBoxAndElement["default"])(bbox, element, entity.transforms);
    };
    var arc = function arc2(entity) {
      var _ellipseOrArc2 = ellipseOrArc(entity.x, entity.y, entity.r, 0, 1, entity.startAngle, entity.endAngle, entity.extrusionZ === -1), bbox0 = _ellipseOrArc2.bbox, element0 = _ellipseOrArc2.element;
      var _addFlipXIfApplicable4 = addFlipXIfApplicable(entity, {
        bbox: bbox0,
        element: element0
      }), bbox = _addFlipXIfApplicable4.bbox, element = _addFlipXIfApplicable4.element;
      return (0, _transformBoundingBoxAndElement["default"])(bbox, element, entity.transforms);
    };
    var piecewiseToPaths = exports.piecewiseToPaths = function piecewiseToPaths2(k, knots, controlPoints) {
      var paths = [];
      var controlPointIndex = 0;
      var knotIndex = k;
      while (knotIndex < knots.length - k + 1) {
        var m = (0, _toPiecewiseBezier.multiplicity)(knots, knotIndex);
        var cp = controlPoints.slice(controlPointIndex, controlPointIndex + k);
        if (k === 4) {
          paths.push('<path d="M '.concat(cp[0].x, " ").concat(cp[0].y, " C ").concat(cp[1].x, " ").concat(cp[1].y, " ").concat(cp[2].x, " ").concat(cp[2].y, " ").concat(cp[3].x, " ").concat(cp[3].y, '" />'));
        } else if (k === 3) {
          paths.push('<path d="M '.concat(cp[0].x, " ").concat(cp[0].y, " Q ").concat(cp[1].x, " ").concat(cp[1].y, " ").concat(cp[2].x, " ").concat(cp[2].y, '" />'));
        }
        controlPointIndex += m;
        knotIndex += m;
      }
      return paths;
    };
    var bezier = function bezier2(entity) {
      var bbox = new _vecks.Box2();
      entity.controlPoints.forEach(function(p) {
        bbox = bbox.expandByPoint(p);
      });
      var k = entity.degree + 1;
      var piecewise = (0, _toPiecewiseBezier["default"])(k, entity.controlPoints, entity.knots);
      var paths = piecewiseToPaths(k, piecewise.knots, piecewise.controlPoints);
      var element = "<g>".concat(paths.join(""), "</g>");
      return (0, _transformBoundingBoxAndElement["default"])(bbox, element, entity.transforms);
    };
    var entityToBoundsAndElement = function entityToBoundsAndElement2(entity) {
      switch (entity.type) {
        case "CIRCLE":
          return circle(entity);
        case "ELLIPSE":
          return ellipse(entity);
        case "ARC":
          return arc(entity);
        case "SPLINE": {
          var hasWeights = entity.weights && entity.weights.some(function(w) {
            return w !== 1;
          });
          if ((entity.degree === 2 || entity.degree === 3) && !hasWeights) {
            try {
              return bezier(entity);
            } catch (err) {
              return polyline(entity);
            }
          } else {
            return polyline(entity);
          }
        }
        case "LINE":
        case "POLYLINE": {
          return polyline(entity);
        }
        case "LWPOLYLINE": {
          return lwpolyline(entity);
        }
        default:
          _logger["default"].warn("entity type not supported in SVG rendering:", entity.type);
          return null;
      }
    };
    var _default = exports["default"] = function _default2(parsed) {
      var entities = (0, _denormalise["default"])(parsed);
      var _entities$reduce = entities.reduce(function(acc, entity, i) {
        var rgb = (0, _getRGBForEntity["default"])(parsed.tables.layers, entity);
        var boundsAndElement = entityToBoundsAndElement(entity);
        if (boundsAndElement) {
          var _bbox = boundsAndElement.bbox, element = boundsAndElement.element;
          if (_bbox.valid) {
            acc.bbox.expandByPoint(_bbox.min);
            acc.bbox.expandByPoint(_bbox.max);
          }
          acc.elements.push('<g stroke="'.concat((0, _rgbToColorAttribute["default"])(rgb), '">').concat(element, "</g>"));
        }
        return acc;
      }, {
        bbox: new _vecks.Box2(),
        elements: []
      }), bbox = _entities$reduce.bbox, elements = _entities$reduce.elements;
      var viewBox = bbox.valid ? {
        x: bbox.min.x,
        y: -bbox.max.y,
        width: bbox.max.x - bbox.min.x,
        height: bbox.max.y - bbox.min.y
      } : {
        x: 0,
        y: 0,
        width: 0,
        height: 0
      };
      return '<?xml version="1.0"?>\n<svg\n  xmlns="http://www.w3.org/2000/svg"\n  xmlns:xlink="http://www.w3.org/1999/xlink" version="1.1"\n  preserveAspectRatio="xMinYMin meet"\n  viewBox="'.concat(viewBox.x, " ").concat(viewBox.y, " ").concat(viewBox.width, " ").concat(viewBox.height, '"\n  width="100%" height="100%"\n>\n  <g stroke="#000000" stroke-width="0.1%" fill="none" transform="matrix(1,0,0,-1,0,0)">\n    ').concat(elements.join("\n"), "\n  </g>\n</svg>");
    };
  }
});

// node_modules/dxf/lib/Helper.js
var require_Helper = __commonJS({
  "node_modules/dxf/lib/Helper.js"(exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", {
      value: true
    });
    exports["default"] = void 0;
    var _logger = _interopRequireDefault(require_logger());
    var _parseString = _interopRequireDefault(require_parseString());
    var _denormalise2 = _interopRequireDefault(require_denormalise());
    var _toSVG2 = _interopRequireDefault(require_toSVG());
    var _toPolylines2 = _interopRequireDefault(require_toPolylines());
    var _groupEntitiesByLayer = _interopRequireDefault(require_groupEntitiesByLayer());
    function _interopRequireDefault(e) {
      return e && e.__esModule ? e : { "default": e };
    }
    function _typeof(o) {
      "@babel/helpers - typeof";
      return _typeof = "function" == typeof Symbol && "symbol" == typeof Symbol.iterator ? function(o2) {
        return typeof o2;
      } : function(o2) {
        return o2 && "function" == typeof Symbol && o2.constructor === Symbol && o2 !== Symbol.prototype ? "symbol" : typeof o2;
      }, _typeof(o);
    }
    function _classCallCheck(a, n) {
      if (!(a instanceof n)) throw new TypeError("Cannot call a class as a function");
    }
    function _defineProperties(e, r) {
      for (var t = 0; t < r.length; t++) {
        var o = r[t];
        o.enumerable = o.enumerable || false, o.configurable = true, "value" in o && (o.writable = true), Object.defineProperty(e, _toPropertyKey(o.key), o);
      }
    }
    function _createClass(e, r, t) {
      return r && _defineProperties(e.prototype, r), t && _defineProperties(e, t), Object.defineProperty(e, "prototype", { writable: false }), e;
    }
    function _toPropertyKey(t) {
      var i = _toPrimitive(t, "string");
      return "symbol" == _typeof(i) ? i : i + "";
    }
    function _toPrimitive(t, r) {
      if ("object" != _typeof(t) || !t) return t;
      var e = t[Symbol.toPrimitive];
      if (void 0 !== e) {
        var i = e.call(t, r || "default");
        if ("object" != _typeof(i)) return i;
        throw new TypeError("@@toPrimitive must return a primitive value.");
      }
      return ("string" === r ? String : Number)(t);
    }
    var Helper = exports["default"] = /* @__PURE__ */ (function() {
      function Helper2(contents) {
        _classCallCheck(this, Helper2);
        if (!(typeof contents === "string")) {
          throw Error("Helper constructor expects a DXF string");
        }
        this._contents = contents;
        this._parsed = null;
        this._denormalised = null;
      }
      return _createClass(Helper2, [{
        key: "parse",
        value: function parse() {
          this._parsed = (0, _parseString["default"])(this._contents);
          _logger["default"].info("parsed:", this.parsed);
          return this._parsed;
        }
      }, {
        key: "parsed",
        get: function get() {
          if (this._parsed === null) {
            this.parse();
          }
          return this._parsed;
        }
      }, {
        key: "denormalise",
        value: function denormalise() {
          this._denormalised = (0, _denormalise2["default"])(this.parsed);
          _logger["default"].info("denormalised:", this._denormalised);
          return this._denormalised;
        }
      }, {
        key: "denormalised",
        get: function get() {
          if (!this._denormalised) {
            this.denormalise();
          }
          return this._denormalised;
        }
      }, {
        key: "group",
        value: function group() {
          this._groups = (0, _groupEntitiesByLayer["default"])(this.denormalised);
        }
      }, {
        key: "groups",
        get: function get() {
          if (!this._groups) {
            this.group();
          }
          return this._groups;
        }
      }, {
        key: "toSVG",
        value: function toSVG() {
          return (0, _toSVG2["default"])(this.parsed);
        }
      }, {
        key: "toPolylines",
        value: function toPolylines() {
          return (0, _toPolylines2["default"])(this.parsed);
        }
      }]);
    })();
  }
});

// node_modules/dxf/lib/index.js
var require_index = __commonJS({
  "node_modules/dxf/lib/index.js"(exports) {
    Object.defineProperty(exports, "__esModule", {
      value: true
    });
    Object.defineProperty(exports, "Helper", {
      enumerable: true,
      get: function get() {
        return _Helper["default"];
      }
    });
    Object.defineProperty(exports, "colors", {
      enumerable: true,
      get: function get() {
        return _colors["default"];
      }
    });
    Object.defineProperty(exports, "config", {
      enumerable: true,
      get: function get() {
        return _config["default"];
      }
    });
    Object.defineProperty(exports, "denormalise", {
      enumerable: true,
      get: function get() {
        return _denormalise["default"];
      }
    });
    Object.defineProperty(exports, "groupEntitiesByLayer", {
      enumerable: true,
      get: function get() {
        return _groupEntitiesByLayer["default"];
      }
    });
    Object.defineProperty(exports, "parseString", {
      enumerable: true,
      get: function get() {
        return _parseString["default"];
      }
    });
    Object.defineProperty(exports, "toPolylines", {
      enumerable: true,
      get: function get() {
        return _toPolylines["default"];
      }
    });
    Object.defineProperty(exports, "toSVG", {
      enumerable: true,
      get: function get() {
        return _toSVG["default"];
      }
    });
    var _config = _interopRequireDefault(require_config());
    var _parseString = _interopRequireDefault(require_parseString());
    var _denormalise = _interopRequireDefault(require_denormalise());
    var _groupEntitiesByLayer = _interopRequireDefault(require_groupEntitiesByLayer());
    var _toPolylines = _interopRequireDefault(require_toPolylines());
    var _toSVG = _interopRequireDefault(require_toSVG());
    var _colors = _interopRequireDefault(require_colors());
    var _Helper = _interopRequireDefault(require_Helper());
    function _interopRequireDefault(e) {
      return e && e.__esModule ? e : { "default": e };
    }
  }
});
export default require_index();
