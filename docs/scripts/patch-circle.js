#!/usr/bin/env node
// Patches dxf-viewer's circle entity parser to expose group code 39 (thickness).
// The upstream parser silently drops it; this fix mirrors the polyline parser.
const fs = require('fs');
const path = require('path');

const file = path.join(__dirname, '../node_modules/dxf-viewer/src/parser/entities/circle.js');
const src = fs.readFileSync(file, 'utf8');

if (src.includes('case 39:')) {
  process.exit(0); // already patched
}

const patched = src.replace(
  'case 40: // radius',
  'case 39: // thickness\n            entity.thickness = curr.value;\n            break;\n        case 40: // radius'
);

if (patched === src) {
  console.error('patch-circle: anchor string not found, patch not applied');
  process.exit(1);
}

fs.writeFileSync(file, patched);
console.log('patch-circle: applied thickness fix to circle.js');
