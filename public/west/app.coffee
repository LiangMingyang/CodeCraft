angular.module('west', [
  'ui.bootstrap',
  'west-router'
])

.filter('richtext', ['$sce', ($sce)->
  (html)->
    $sce.trustAsHtml(html)
])
.controller('main', ($scope, $timeout)->
  $scope.now = new Date()
  update = ()->
    $scope.now = new Date()
    $timeout(update, 1000)
  update()

  $scope.slides = [
    image: "/west/index_files/41533c1509a7aa914d240e2323ec931d.jpg"
    text: "讲话"
  ,
    image: "/west/index_files/1295865472c035ed7c2b8cbea64c9fd7.jpg"
    text: "视察"
  ,
    image: "/west/index_files/429101300209f00ec774cc4cda0f84e9.jpg"
    text: "指导"
  ]
  $scope.news_list = [
    title: '一篇新闻'
    content: 'blabla'
    created_at: '2016-01-03 23:33'
    updated_at: '2016-01-04 07:11'
  ,
    title: '学而时习之，不亦说乎'
    content: 'RT'
    created_at: '2016-01-02 23:33'
    updated_at: '2016-01-03 07:11'
  ,
    title: '千乘之国，敬事而信'
    content: 'RT'
    created_at: '2016-01-01 23:33'
    updated_at: '2016-01-02 07:11'
  ,
    title: '谨而信，泛爱众而亲仁'
    content: 'RT'
    created_at: '2015-12-30 23:33'
    updated_at: '2015-12-31 07:11'
  ,
    title: '温良恭俭让'
    content: 'RT'
    created_at: '2015-12-29 23:33'
    updated_at: '2015-12-30 07:11'
  ,
    title: '慎终追远，民德归厚'
    content: 'RT'
    created_at: '2015-12-28 23:33'
    updated_at: '2015-12-31 07:11'
  ]

  $scope.about = "
  <p>
  &nbsp;&nbsp;&nbsp;&nbsp;中国西部研究与发展促进会健康中国推进工作委员会，是中国西部研究与发展促进会的直属机构。<br>
  &nbsp;&nbsp;&nbsp;&nbsp;委员会以党的科学发展观为指导，促进我国西部地区健康中国战略推进工作有序发展为目标，认真做好改善西部地区医疗卫生条件、促进人才与信息交流、为有需要的地区提供医疗卫生帮扶工作。为政府主管部门和医疗卫生领域的科研机构、生产企业、设计、检测机构、大专院校、学术团体提供服务；协调政府机构或组织与企业之间、医疗卫生科研机构与企业之间、企业与企业之间、医疗卫生产品与用户之间的关系，发挥桥梁与纽带作用，促进我国医疗公共卫生事业的健康发展。<br>
  &nbsp;&nbsp;&nbsp;&nbsp;委员会办公地点设在北京。<br>
  </p>
  "

  $scope.expert = "我就是专家"

  $scope.notify = "
  <strong>“健康中国2020”</strong>：改善城乡居民健康状况，提高国民健康生活质量，减少不同地区健康状况差异，主要健康指标基本达到中等发达国家水平。<br>&nbsp;&nbsp;&nbsp;&nbsp;到2015年，基本医疗卫生制度初步建立，使全体国民人人拥有基本医疗保障、人人享有基本公共卫生服务，医疗卫生服务可及性明显增强，地区间人群健康状况和资源配置差异明显缩小，国民健康水平居于发展中国家前列。<br>&nbsp;&nbsp;&nbsp;&nbsp;到2020年，完善覆盖城乡居民的基本医疗卫生制度，实现人人享有基本医疗卫生服务，医疗保障水平不断提高，卫生服务利用明显改善，地区间人群健康差异进一步缩小，国民健康水平达到中等发达国家水平。
  "

  $scope.contact = '''
  <p style="margin-top:6.0pt;margin-right:0in;margin-bottom:6.0pt;margin-left:
  0in;line-height:21.0pt"><font size="3" color="black" face="宋体"><span lang="ZH-CN" style="font-size: 12pt;">健康中国推进工作委员会</span></font><font color="black" face="simsun"><span style="font-family: simsun, serif;"><o:p></o:p></span></font></p><p style="margin-top:6.0pt;margin-right:0in;margin-bottom:6.0pt;margin-left:
  0in;line-height:21.0pt"><font size="3" color="black" face="宋体"><span lang="ZH-CN" style="font-size: 12pt;">地址：<span class="js_location_string" style="border-bottom-width: 1px; border-bottom-style: dashed; border-bottom-color: rgb(171, 171, 171); z-index: 1; position: static;" isout="1">北京市西城区永安路</span></span></font><font color="black" face="simsun"><span style="font-family: simsun, serif;">106</span></font><font color="black"><span lang="ZH-CN">号</span></font><font color="black" face="simsun"><span style="font-family: simsun, serif;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <o:p></o:p></span></font></p><p style="margin-top:6.0pt;margin-right:0in;margin-bottom:6.0pt;margin-left:
  0in;line-height:21.0pt"><font size="3" color="black" face="宋体"><span lang="ZH-CN" style="font-size: 12pt;">邮编：</span></font><font color="black" face="simsun"><span style="font-family: simsun, serif;">100050<o:p></o:p></span></font></p><p style="margin-top:6.0pt;margin-right:0in;margin-bottom:6.0pt;margin-left:
  0in;line-height:21.0pt"><font size="3" color="black" face="宋体"><span lang="ZH-CN" style="font-size: 12pt;">电话号码：</span></font><font color="black" face="simsun"><span style="font-family: simsun, serif;">010-83167988<o:p></o:p></span></font></p><p style="margin-top:6.0pt;margin-right:0in;margin-bottom:6.0pt;margin-left:
  0in;line-height:21.0pt"><font size="3" color="black" face="宋体"><span lang="ZH-CN" style="font-size: 12pt;">传真号码：</span></font><font color="black" face="simsun"><span style="font-family: simsun, serif;">010-83151568<o:p></o:p></span></font></p><p class="MsoSubtitle" style="text-align:justify;text-justify:inter-ideograph">
  </p><p style="margin-top:6.0pt;margin-right:0in;margin-bottom:6.0pt;margin-left:
  0in;line-height:21.0pt"><font size="3" face="宋体"><span lang="ZH-CN" style="font-size:
  12.0pt">电子邮箱：</span><a href="mailto:44228557@qq.com"><font face="simsun"><span style="font-family:&quot;simsun&quot;,serif">44228557@qq.com</span></font></a>&nbsp;&nbsp;</font><font color="black" face="simsun"><span style="font-family: simsun, serif;"><o:p></o:p></span></font></p>
  '''
)