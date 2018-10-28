$fn=60; // rendering option, see https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Other_Language_Features#$fa,_$fs_and_$fn

use <ducket.scad>

// 8-sided, nothing fancy
ducket(nsides=8, r=12, h=3);

// same coin, but with a little lip around it
//ducket(nsides=8, r=12, h=3, lip_h=2, lip_w=2);

// same as previous, but now with crenellations for stacking
//ducket(nsides=8, r=12, h=3, lip_h=2, lip_w=2, crenellated=true);

// same as previous, but now with crenellations for stacking
//ducket(nsides=8, r=12, h=3, lip_h=2, lip_w=2, bumps=true);

// of course you can get silly with it
//ducket(nsides=8, r=12, h=3, lip_h=2, lip_w=7, bumps=true);

// ...or sillier
//ducket(nsides=8, r=12, h=3, lip_h=12, lip_w=7, bumps=true, crenellated=true);
