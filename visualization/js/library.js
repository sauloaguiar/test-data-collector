
//specify width and height
var w = 1200;
var h = 200;
//add option for padding within the barchart
var padding = 8;

/**
 * build a bar chart - 1
 */
//set title
d3.select('#test-container').append('h5').text('Bar chart 1 - no correction');

d3.json("data/data.json", function(data) {

  //create svg and add to the DOM
  var svg = d3.select('#test-container').append('svg').attr('width', w).attr('height', h);

  // defining scales
  var scaleX = d3.scale.linear()
  	.domain([0, d3.max(data, function(d) { return data.length; })])
  	.range([0, w]);//set output range from 0 to width of svg
  var scaleY = d3.scale.linear()
  	.domain([0, d3.max(data, function(d) { return d["tests"]; })])
  	.range([h, 0]);//set output range from height to 0 of svg - it swaps the svg direction of height in the svg system

  svg.selectAll('rect')
  	.data(data)
  	.enter()
  	.append('rect')
  	.attr('x', function(d, i) {
  		return i * (w / data.length); //works well for basic charts but D3 scales are better
  	})
  	.attr('y', function(d){
      return h - d.tests;
    })
  	.attr('width', 2)              // constant just to see the graph - need to it in a relative way
  	.attr('height', function (d) {
      return d.tests; //outputs bars from upper left corner (they grow down, not up) due to svg upper-left corner for x and y - origin is top left
  	})
    .attr("transform", "translate(30, 0)");

  /*svg.selectAll('text')
    .data(data)
    .enter()
    .append('text')
    .text(function(d){
      return d.sha1.substring(0,6);
    })
    .attr("transform", "rotate(-90)")
    .attr('x', function(d, i) {
      //return (h / d.sha1.substring(0,6).length) + ((h / d.sha1.substring(0,6).length) / 2) - 6; //set posn of text tp centred in bar... -6 for font-size / 2
      return 15;
    })
    .attr('y', function(d, i) {
      return w - d.tests - 10; //set labels to the top of the bars with some taken off (-5) to move above bar itself
    });
  */

  var yAxis = d3.svg.axis()
    .scale(scaleY)        // scale done in the beginnig of the script
    .orient('right');     // the ticks go on the left of the graph, with the text on the right

  svg.append('g')
    .attr('class', 'y axis')
    .call(yAxis)
});
