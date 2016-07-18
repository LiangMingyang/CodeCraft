@drawRating = ()->
  @series ?= []
  $("#panel").highcharts
    title:
      text: "Rating变化图"
      x: -20 #center

    subtitle:
      text: "Source: 北航ACM集训队"
      x: -20

    xAxis:
      categories: [1..100]

    yAxis:
      title:
        text: "Rating"

      plotLines: [
        value: 0
        width: 1
        color: "#808080"
      ]

    tooltip:
      valueSuffix: ""

    legend:
      layout: "vertical"
      align: "right"
      verticalAlign: "middle"
      borderWidth: 0

    series: @series

