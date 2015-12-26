module.exports = (db) ->
  Contest = db.models.contest
  ContestProblemList = db.models.contest_problem_list
  Group = db.models.group
  Judge = db.models.judge
  Membership = db.models.membership
  Problem = db.models.problem
  Submission = db.models.submission
  SubmissionCode = db.models.submission_code
  User = db.models.user
  Message = db.models.message
  Issue = db.models.issue
  IssueReply = db.models.issue_reply

  testUser = undefined
  testGroup = undefined
  testContest = undefined
  testProblem = undefined
  db.Promise.resolve()
#  .then -> #create users
#    group = {"id":7,"name":"BCPC2015Final","description":"","access_level":"private","creator_id":1,"users":[{"id":1,"username":"test@test.com","password":"sha1$c35317b2$1$19b30149c6d4d569292962f0a0cdec567545b807","description":" 超级管理员","school":"北京航空航天大学","college":"软件学院","student_id":"","phone":null,"nickname":" 超级管理员","rating":1000,"is_super_admin":true,"last_login":"2015-12-19T12:58:36.000Z","membership":{"access_level":"owner","user_id":1,"group_id":7}},{"id":11,"username":"13654840887@163.com","password":"sha1$c43c42f9$1$2eac8c9fcea35a90b8dd7f591f1d3e7e820cd639","description":"","school":"北京航空航天大学","college":"软件学院","student_id":"14211116","phone":"13021211030","nickname":"付博","rating":1000,"is_super_admin":false,"last_login":"2015-12-19T14:35:44.000Z","membership":{"access_level":"member","user_id":11,"group_id":7}},{"id":16,"username":"Midor1@outlook.com","password":"sha1$ed9f1375$1$97238eafe8b8274907eb1ca664ed51d48d411423","description":"がんばらない~~~~","school":"北京航空航天大学","college":"软件学院","student_id":"15211087","phone":"15600537855","nickname":"侯传嘉","rating":1000,"is_super_admin":false,"last_login":"2015-12-18T13:12:58.000Z","membership":{"access_level":"member","user_id":16,"group_id":7}},{"id":21,"username":"yrsty@hotmail.com","password":"sha1$012df97f$1$2933b5d3566a13cf57cdf71c0492f18dc4431b60","description":"","school":"北京航空航天大学","college":"软件学院","student_id":"15211010","phone":"13842695912","nickname":"羊瑞","rating":1000,"is_super_admin":false,"last_login":"2015-12-18T10:09:44.000Z","membership":{"access_level":"member","user_id":21,"group_id":7}},{"id":22,"username":"mgr2009@msn.com","password":"sha1$35a10889$1$334bd76dbb83409f2f12e65b9b600f5ab56cd4d2","description":"","school":"北京航空航天大学","college":"软件学院","student_id":"14211076","phone":"13020007086","nickname":"马国瑞","rating":1000,"is_super_admin":false,"last_login":"2015-12-19T04:08:19.000Z","membership":{"access_level":"member","user_id":22,"group_id":7}},{"id":24,"username":"807447907@qq.com","password":"sha1$5056f79a$1$03ced122b89eb98a3747547d07769d34cf217038","description":"我是外国来的渣渣","school":"北京航空航天大学","college":"软件学院","student_id":"15211121","phone":"18010486322","nickname":"罗震宇","rating":1000,"is_super_admin":false,"last_login":"2015-12-19T05:00:29.000Z","membership":{"access_level":"member","user_id":24,"group_id":7}},{"id":29,"username":"xieyaoyao@yeah.net","password":"sha1$3348cd5e$1$c54f6af0180e4b9a6b70fbababbeedccb5f9c80e","description":"","school":"北京航空航天大学","college":"软件学院","student_id":"15211078","phone":"13121261525","nickname":"谢瑶瑶","rating":1000,"is_super_admin":false,"last_login":"2015-12-19T13:38:12.000Z","membership":{"access_level":"member","user_id":29,"group_id":7}},{"id":31,"username":"modricwang@126.com","password":"sha1$70792fcb$1$fb07db24b1a34bb32e79b8b90347ed73ed6d9d1c","description":"CMCC","school":"北京航空航天大学","college":"软件学院","student_id":"15211088","phone":"13121269982","nickname":"王意如","rating":1000,"is_super_admin":false,"last_login":"2015-12-19T13:28:24.000Z","membership":{"access_level":"member","user_id":31,"group_id":7}},{"id":33,"username":"1040386493@qq.com","password":"sha1$a2e722b7$1$d283a229fe9f6741916e6f290c460238ef97e147","description":"","school":"北京航空航天大学","college":"软件学院","student_id":"15211073","phone":"13121253160","nickname":"张宸华","rating":1000,"is_super_admin":false,"last_login":"2015-12-18T14:01:27.000Z","membership":{"access_level":"member","user_id":33,"group_id":7}},{"id":39,"username":"578218819@qq.com","password":"sha1$46ba4d1e$1$63af1a976ba174904b80847dae9ba650c0e0b9e2","description":"","school":"北京航空航天大学","college":"软件学院","student_id":"13271136","phone":"13041231913","nickname":"欧阳植昊","rating":1000,"is_super_admin":false,"last_login":"2015-12-19T14:05:21.000Z","membership":{"access_level":"member","user_id":39,"group_id":7}},{"id":41,"username":"1905217814@qq.com","password":"sha1$eea76cad$1$f71741346af918efaca77a03bf91e0f877117bef","description":"","school":"北京航空航天大学","college":"软件学院","student_id":"15211048","phone":"18011308968","nickname":"蒋泳波","rating":1000,"is_super_admin":false,"last_login":"2015-12-18T10:26:21.000Z","membership":{"access_level":"member","user_id":41,"group_id":7}},{"id":42,"username":"lxx20120415@sina.com","password":"sha1$65323b49$1$a60083751eb268aeba847a1578863bbb8b8ca4eb","description":"","school":"北京航空航天大学","college":"软件学院","student_id":"15211033","phone":"13121216057","nickname":"李修璇","rating":1000,"is_super_admin":false,"last_login":"2015-12-19T07:11:33.000Z","membership":{"access_level":"member","user_id":42,"group_id":7}},{"id":44,"username":"zhaoqy042@sina.com","password":"sha1$f1de4e08$1$555f2b6f6e5ab094ef2f4dc3ec58b0a982697c14","description":"","school":"北京航空航天大学","college":"软件学院","student_id":"15211006","phone":"13167589706","nickname":"赵桐","rating":1000,"is_super_admin":false,"last_login":"2015-12-18T12:52:22.000Z","membership":{"access_level":"member","user_id":44,"group_id":7}},{"id":46,"username":"chd19970620@163.com","password":"sha1$559cb322$1$12d3e130b0082a87d731fe2e08b8624dede46f81","description":"这家伙很懒，什么都没写","school":"北京航空航天大学","college":"软件学院","student_id":"15211024","phone":"13121220687","nickname":"陈亨达","rating":1000,"is_super_admin":false,"last_login":"2015-12-19T13:50:10.000Z","membership":{"access_level":"member","user_id":46,"group_id":7}},{"id":59,"username":"565530192@qq.com","password":"sha1$28eed7b0$1$98577b6bb4a12978d8517b4625e7e3f973e4fadb","description":"","school":"北京航空航天大学","college":"软件学院","student_id":"15211112","phone":"18645919233","nickname":"公绪民","rating":1000,"is_super_admin":false,"last_login":"2015-12-18T10:06:10.000Z","membership":{"access_level":"member","user_id":59,"group_id":7}},{"id":70,"username":"1049909407@qq.com","password":"sha1$40eb4c10$1$45b5f572d272e00cad7929fbba013129633812f3","description":"","school":"北京航空航天大学","college":"软件学院","student_id":"15211090","phone":"15600528733","nickname":"杨承昊","rating":1000,"is_super_admin":false,"last_login":"2015-12-18T16:00:16.000Z","membership":{"access_level":"member","user_id":70,"group_id":7}},{"id":73,"username":"2273925535@qq.com","password":"sha1$418f0e51$1$87f65411a97c4ff355124cb191b3835a77b55b8a","description":"","school":"北京航空航天大学","college":"软件学院","student_id":"15211077","phone":"13717980609","nickname":"麻慧","rating":1000,"is_super_admin":false,"last_login":"2015-12-18T13:31:32.000Z","membership":{"access_level":"member","user_id":73,"group_id":7}},{"id":76,"username":"q113518006@163.com","password":"sha1$276b181f$1$1102be3b9a224630b3c1c062beda9ee389bd2b98","description":"","school":"北京航空航天大学","college":"软件学院","student_id":"15211051","phone":"13121209562","nickname":"王子烈","rating":1000,"is_super_admin":false,"last_login":"2015-12-18T10:27:41.000Z","membership":{"access_level":"member","user_id":76,"group_id":7}},{"id":77,"username":"280943872@qq.com","password":"sha1$4472b39f$1$88c82ed3f871d929fd6104d515d330a83f80ad1e","description":"","school":"北京航空航天大学","college":"软件学院","student_id":"15211068","phone":"13717986800","nickname":"谭伟豪","rating":1000,"is_super_admin":false,"last_login":"2015-12-18T12:51:06.000Z","membership":{"access_level":"member","user_id":77,"group_id":7}},{"id":83,"username":"weiyidi@buaa.edu.cn","password":"sha1$2c1fb414$1$4b75c339478efc9b807ec44779bd0f7771e23b73","description":"","school":"北京航空航天大学","college":"软件学院","student_id":"15211028","phone":"13121231209","nickname":"魏艺迪","rating":1000,"is_super_admin":false,"last_login":"2015-12-18T15:26:41.000Z","membership":{"access_level":"member","user_id":83,"group_id":7}},{"id":87,"username":"muzhi.yu@foxmail.com","password":"sha1$1b1af860$1$2c94d4aa59026d09da20a4c59638455bfd1ff130","description":"","school":"北京航空航天大学","college":"软件学院","student_id":"15211063","phone":"13121250993","nickname":"于牧之","rating":1000,"is_super_admin":false,"last_login":"2015-12-18T10:42:57.000Z","membership":{"access_level":"member","user_id":87,"group_id":7}},{"id":89,"username":"1521150375@qq.com","password":"sha1$f19b7e9a$1$088f8b14623b1b022859900c546a001c5023a554","description":"已经被虐爆了","school":"北京航空航天大学","college":"软件学院","student_id":"15211053","phone":"17717626995","nickname":"龚霞","rating":1000,"is_super_admin":false,"last_login":"2015-12-18T15:42:20.000Z","membership":{"access_level":"member","user_id":89,"group_id":7}},{"id":91,"username":"duhao110101@buaa.edu.cn","password":"sha1$85a963f6$1$ed7a779b22ebfc248ddfcce6b289580e21c586cc","description":"","school":"北京航空航天大学","college":"软件学院","student_id":"15211106","phone":"13121273660","nickname":"杜昊","rating":1000,"is_super_admin":false,"last_login":"2015-12-19T12:51:53.000Z","membership":{"access_level":"member","user_id":91,"group_id":7}},{"id":96,"username":"490199397@qq.com","password":"sha1$145545fa$1$78dd03e40611e29ee8c7595643e6c0f83e82d43e","description":"我是小弱渣 求大神提点 求不虐","school":"北京航空航天大学","college":"软件学院","student_id":"15211102","phone":"13261896800","nickname":"武仪","rating":1000,"is_super_admin":false,"last_login":"2015-12-18T14:18:05.000Z","membership":{"access_level":"member","user_id":96,"group_id":7}},{"id":106,"username":"yuyyi51@126.com","password":"sha1$4464d71e$1$158e64fc8f6bac03932c7ea09b98300b5abdfa37","description":"","school":"北京航空航天大学","college":"软件学院","student_id":"15211105","phone":"13521981330","nickname":"于涌溢","rating":1000,"is_super_admin":false,"last_login":"2015-12-19T03:15:59.000Z","membership":{"access_level":"member","user_id":106,"group_id":7}},{"id":111,"username":"carl710082796@hotmail.com","password":"sha1$ef4afb93$1$8c4cc823b1930987eddfa29639b1853517ffc4de","description":"我是绝对不会放弃的，因为，这就是我的忍道!","school":"北京航空航天大学","college":"软件学院","student_id":"15211060","phone":"13121209779","nickname":"周毅","rating":1000,"is_super_admin":false,"last_login":"2015-12-18T10:22:15.000Z","membership":{"access_level":"member","user_id":111,"group_id":7}},{"id":114,"username":"350012950@qq.com","password":"sha1$85aaaf1d$1$ba7c7a050c0018a42de1aef9ec7caa8321092072","description":"","school":"北京航空航天大学","college":"软件学院","student_id":"14271121","phone":"18508126686","nickname":"钟金成","rating":1000,"is_super_admin":false,"last_login":"2015-12-18T13:10:53.000Z","membership":{"access_level":"member","user_id":114,"group_id":7}},{"id":119,"username":"hhd1997@sina.cn","password":"sha1$fe745f41$1$1179f8a080a75bd243764e66fc4832d2a2db55d0","description":"","school":"北京航空航天大学","college":"软件学院","student_id":"15211055","phone":"15101600877","nickname":"黄浩东","rating":1000,"is_super_admin":false,"last_login":"2015-12-18T13:16:26.000Z","membership":{"access_level":"member","user_id":119,"group_id":7}},{"id":136,"username":"664751610@qq.com","password":"sha1$ac3a6075$1$afc6f6ffe55900b1f5fcc76bcfa54315cb828dd8","description":"","school":"北京航空航天大学","college":"软件学院","student_id":"15211072","phone":"13121232783","nickname":"胡智昊","rating":1000,"is_super_admin":false,"last_login":"2015-12-17T13:38:09.000Z","membership":{"access_level":"member","user_id":136,"group_id":7}},{"id":144,"username":"fanglei212@outlook.com","password":"sha1$58b7c41b$1$0c6cf646c95b5f753bb4aa4fddf855cd03acd0eb","description":"","school":"北京航空航天大学","college":"软件学院","student_id":"15211040","phone":"13717979538","nickname":"方磊","rating":1000,"is_super_admin":false,"last_login":"2015-12-18T10:31:05.000Z","membership":{"access_level":"member","user_id":144,"group_id":7}},{"id":145,"username":"2305990801@qq.com","password":"sha1$e91f217d$1$14e62aeb16f01c84cd28b9fee824e95d9877d790","description":"2015C++第二次上机G题弃疗","school":"北京航空航天大学","college":"软件学院","student_id":"15211034","phone":"13718837696","nickname":"武康钊","rating":1000,"is_super_admin":false,"last_login":"2015-12-18T10:24:50.000Z","membership":{"access_level":"member","user_id":145,"group_id":7}},{"id":171,"username":"383303791@qq.com","password":"sha1$62ddf23a$1$67dfb0f6d735a6eecbea5ad430ecb88c78b714ba","description":"","school":"北京航空航天大学","college":"软件学院","student_id":"15211046","phone":"13121229751","nickname":"潘梓宁","rating":1000,"is_super_admin":false,"last_login":"2015-12-18T13:19:36.000Z","membership":{"access_level":"member","user_id":171,"group_id":7}},{"id":179,"username":"907405474@qq.com","password":"sha1$0406e746$1$39d55dbe2425a381a33c6f41abe2f7cc15b7a9ea","description":"","school":"北京航空航天大学","college":"软件学院","student_id":"14211039","phone":"17801006729","nickname":"张轩铭","rating":1000,"is_super_admin":false,"last_login":"2015-12-17T10:30:52.000Z","membership":{"access_level":"member","user_id":179,"group_id":7}},{"id":183,"username":"yujifan0326@163.com","password":"sha1$8953cc4f$1$ac68b4d2f9c77799c2ff6af54e661a2084e32ae6","description":"","school":"北京航空航天大学","college":"软件学院","student_id":"14211065","phone":"13204210266","nickname":"于济凡","rating":1000,"is_super_admin":false,"last_login":"2015-12-16T12:21:16.000Z","membership":{"access_level":"member","user_id":183,"group_id":7}},{"id":203,"username":"snbjzf@163.com","password":"sha1$c15f915f$1$cb05e1dc3a21cc9696483ee268e906890c035db5","description":"","school":"北京航空航天大学","college":"软件学院","student_id":"14211067","phone":"17801004325","nickname":"朱福","rating":1000,"is_super_admin":false,"last_login":"2015-12-18T11:56:47.000Z","membership":{"access_level":"member","user_id":203,"group_id":7}},{"id":255,"username":"842491613@qq.com","password":"sha1$4358a257$1$52a5c5cc124af72ee3f15bbd51a886c21388bb01","description":"","school":"北京航空航天大学","college":"软件学院","student_id":"14211068","phone":"13020033910","nickname":"郑良锋","rating":1000,"is_super_admin":false,"last_login":"2015-12-17T02:07:37.000Z","membership":{"access_level":"member","user_id":255,"group_id":7}},{"id":276,"username":"wind_rises@163.com","password":"sha1$28842b1e$1$645310b1bc015e2e92ebdbf7a31013284a92ddf0","description":"最爱的就是做物理实验了","school":"北京航空航天大学","college":"软件学院","student_id":"14211099","phone":"17801005431","nickname":"朱时杰","rating":1000,"is_super_admin":false,"last_login":"2015-12-18T14:50:30.000Z","membership":{"access_level":"member","user_id":276,"group_id":7}},{"id":280,"username":"moxwell@qq.com","password":"sha1$71048c8c$1$e47a558d152c02a2a9fc86bc5d196489b61e897a","description":"","school":"北京航空航天大学","college":"软件学院","student_id":"14211112","phone":"15650791996","nickname":"莫永佳","rating":1000,"is_super_admin":false,"last_login":"2015-12-17T10:41:09.000Z","membership":{"access_level":"member","user_id":280,"group_id":7}},{"id":285,"username":"15211070@buaa.edu.cn","password":"sha1$89421ce0$1$998ee9d80e4fa968f277276aae178cf2465d5a65","description":"","school":"北京航空航天大学","college":"软件学院","student_id":"15211070","phone":"15600586900","nickname":"肖暐奇","rating":1000,"is_super_admin":false,"last_login":"2015-12-18T12:46:13.000Z","membership":{"access_level":"member","user_id":285,"group_id":7}},{"id":299,"username":"879531673@qq.com","password":"sha1$52fd45ed$1$0c5f9c12916522d61006fbb354cbcf481c1a48fd","description":"","school":"北京航空航天大学","college":"软件学院","student_id":"14211062","phone":"18510486195","nickname":"杨晨","rating":1000,"is_super_admin":false,"last_login":"2015-12-19T13:55:21.000Z","membership":{"access_level":"member","user_id":299,"group_id":7}},{"id":310,"username":"642206119@qq.com","password":"sha1$34cb02d9$1$d4961079085977a4662822bda530f05eb4674033","description":"","school":"北京航空航天大学","college":"软件学院","student_id":"14211135","phone":"13483428092","nickname":"寇宇增","rating":1000,"is_super_admin":false,"last_login":"2015-12-17T11:18:32.000Z","membership":{"access_level":"member","user_id":310,"group_id":7}},{"id":369,"username":"zwx0130@buaa.edu.cn","password":"sha1$c9cec201$1$9a32f50ac78c7dbd6734361f0e6e45a2a2a139ab","description":"","school":"北京航空航天大学","college":"计算机学院","student_id":"14031127","phone":"13020027387","nickname":"郑文轩","rating":1000,"is_super_admin":false,"last_login":"2015-12-16T14:34:14.000Z","membership":{"access_level":"member","user_id":369,"group_id":7}},{"id":421,"username":"1023964019@qq.com","password":"sha1$f39d694f$1$83e4d2257c57d02538f77bb13b770f8262c01fb6","description":"膜昂也要讲基本法","school":"北京航空航天大学","college":"计算机学院","student_id":"15061083","phone":"18811526069","nickname":"黄鑫","rating":1000,"is_super_admin":false,"last_login":"2015-12-19T08:08:10.000Z","membership":{"access_level":"member","user_id":421,"group_id":7}},{"id":486,"username":"2934364887@qq.com","password":"sha1$8d0ab44d$1$fc46fffee7af119e945393f97aeecb4af7c8c13b","description":"很弱很弱= =。","school":"北京航空航天大学","college":"软件学院","student_id":"吴举豪","phone":"13020033095","nickname":"14211098","rating":1000,"is_super_admin":false,"last_login":"2015-12-17T14:20:42.000Z","membership":{"access_level":"member","user_id":486,"group_id":7}},{"id":488,"username":"a734547007@vip.qq.com","password":"sha1$8d5094a7$1$ab3ebc8116130c2c8d6bee04b43d8ed3d29b43e9","description":"","school":"北京航空航天大学","college":"计算机学院","student_id":"15131080","phone":"13121202867","nickname":"胡珅","rating":1000,"is_super_admin":false,"last_login":"2015-12-17T12:06:55.000Z","membership":{"access_level":"member","user_id":488,"group_id":7}},{"id":493,"username":"295512972@qq.com","password":"sha1$6c6f8ac9$1$97f798f9604dba885acc8ab5f715b0940bb79893","description":"","school":"北京航空航天大学","college":"计算机学院","student_id":"15061053","phone":"13121222631","nickname":"金代圣","rating":1000,"is_super_admin":false,"last_login":"2015-12-18T15:50:12.000Z","membership":{"access_level":"member","user_id":493,"group_id":7}},{"id":495,"username":"ACplus@buaa.edu.cn","password":"sha1$cb265bac$1$dc2140148ab03576bf5b420fc8814c848d151eae","description":"","school":"北京航空航天大学","college":"计算机学院","student_id":"14151198","phone":"17801004314","nickname":"高威","rating":1000,"is_super_admin":false,"last_login":"2015-12-19T06:01:12.000Z","membership":{"access_level":"member","user_id":495,"group_id":7}},{"id":496,"username":"454537653@qq.com","password":"sha1$4f635e8b$1$72a31652b3c04cec356650d395303f58387bbd80","description":"","school":"北京航空航天大学","college":"计算机学院","student_id":"14061056","phone":"13021227021","nickname":"杨子琛","rating":1000,"is_super_admin":false,"last_login":"2015-12-19T03:28:26.000Z","membership":{"access_level":"member","user_id":496,"group_id":7}},{"id":500,"username":"fwtt20071028@126.com","password":"sha1$d18a8938$1$d048e6ed3cb65eb4cd6c156702fb06b1a203a59b","description":"","school":"北京航空航天大学","college":"计算机学院","student_id":"14061197","phone":"13020007662","nickname":"冯炜韬","rating":1000,"is_super_admin":false,"last_login":"2015-12-19T05:13:23.000Z","membership":{"access_level":"member","user_id":500,"group_id":7}},{"id":501,"username":"1301280096@qq.com","password":"sha1$511d740f$1$facf4f11f66decd43c8ebce84e3f50846cf242ab","description":"","school":"北京航空航天大学","college":"计算机学院","student_id":"15061176","phone":"15339229909","nickname":"张明远","rating":1000,"is_super_admin":false,"last_login":"2015-12-19T02:47:55.000Z","membership":{"access_level":"member","user_id":501,"group_id":7}},{"id":504,"username":"12536680@qq.com","password":"sha1$21c3b3d3$1$3a69d5d6e386b4ede469e87fe83a12fa3776ff26","description":"你在看我的简介？","school":"北京航空航天大学","college":"计算机学院","student_id":"15061043","phone":"13121208512","nickname":"史雨轩","rating":1000,"is_super_admin":false,"last_login":"2015-12-19T04:05:15.000Z","membership":{"access_level":"member","user_id":504,"group_id":7}},{"id":507,"username":"bh704788525@sina.com","password":"sha1$8e334584$1$8e45b4614db6cb08a190d4cbc8ffd92461ce1784","description":"","school":"北京航空航天大学","college":"计算机学院","student_id":"14061043","phone":"13261052182","nickname":"冯岩","rating":1000,"is_super_admin":false,"last_login":"2015-12-18T10:09:52.000Z","membership":{"access_level":"member","user_id":507,"group_id":7}},{"id":511,"username":"weiguanyu@buaa.edu.cn","password":"sha1$f1e2e288$1$6540e8324232bea45bb21b4953ad4503b5b51675","description":"","school":"北京航空航天大学","college":"计算机学院","student_id":"15061143","phone":"13121225891","nickname":"韦冠宇","rating":1000,"is_super_admin":false,"last_login":"2015-12-17T10:30:41.000Z","membership":{"access_level":"member","user_id":511,"group_id":7}},{"id":512,"username":"289364855@qq.com","password":"sha1$52cbedc0$1$0e006dd35ec9f1acc624c3fee77a4eb817f4d179","description":"","school":"北京航空航天大学","college":"计算机学院","student_id":"15061106","phone":"13121261361","nickname":"林鑫","rating":1000,"is_super_admin":false,"last_login":"2015-12-18T16:24:28.000Z","membership":{"access_level":"member","user_id":512,"group_id":7}},{"id":514,"username":"291045048@qq.com","password":"sha1$8d13fe47$1$9b14a07759881d660eb5adf06fb495e71139faad","description":"噫。你在看我的简介233333333","school":"北京航空航天大学","college":"计算机学院","student_id":"14011100","phone":"17801016282","nickname":"赵奕","rating":1000,"is_super_admin":false,"last_login":"2015-12-19T04:28:31.000Z","membership":{"access_level":"member","user_id":514,"group_id":7}},{"id":515,"username":"kun_lj@qq.com","password":"sha1$953ad9ab$1$4a850c81a1b59d0899ebd6ee7390e99c27ebf1f7","description":"","school":"北京航空航天大学","college":"计算机学院","student_id":"14031134","phone":"13520367253","nickname":"李嘉锟","rating":1000,"is_super_admin":false,"last_login":"2015-12-19T03:55:15.000Z","membership":{"access_level":"member","user_id":515,"group_id":7}},{"id":517,"username":"379145124@qq.com","password":"sha1$128c2619$1$bf16098475aaf6ef3be1ae1e3cb1a872c1880519","description":"我要上春晚！","school":"北京航空航天大学","college":"计算机学院","student_id":"15061199","phone":"13810034879","nickname":"李奕君","rating":1000,"is_super_admin":false,"last_login":"2015-12-19T04:21:39.000Z","membership":{"access_level":"member","user_id":517,"group_id":7}},{"id":520,"username":"529508940@qq.com","password":"sha1$4cf1effb$1$c2a9f7df2486c9c9f01a8693aae68c94bf7d09de","description":"","school":"北京航空航天大学","college":"软件学院","student_id":"14051186","phone":"13021211360","nickname":"李元衡","rating":1000,"is_super_admin":false,"last_login":"2015-12-16T12:34:34.000Z","membership":{"access_level":"member","user_id":520,"group_id":7}},{"id":527,"username":"shell0011@163.com","password":"sha1$748523a3$1$7221539e8f1a7b37fbe002732864c3576eacf8be","description":"","school":"北京航空航天大学","college":"计算机学院","student_id":"15061023","phone":"13121265916","nickname":"李何贝子","rating":1000,"is_super_admin":false,"last_login":"2015-12-19T07:38:53.000Z","membership":{"access_level":"member","user_id":527,"group_id":7}},{"id":537,"username":"alephjhm@gmail.com","password":"sha1$ad7a117a$1$90f7e477a7895b8306bb2ce256d7181e1b54966a","description":"","school":"北京航空航天大学","college":"计算机学院","student_id":"14231014","phone":"15712937507","nickname":"金晖明","rating":1000,"is_super_admin":false,"last_login":"2015-12-18T08:54:25.000Z","membership":{"access_level":"member","user_id":537,"group_id":7}},{"id":540,"username":"1532422769@qq.com","password":"sha1$68b192d0$1$5fed69d2a90b1dee55544862185ec3c1bf19b8a8","description":null,"school":"北京航空航天大学","college":"-----","student_id":"15031211","phone":"15011328210","nickname":"陈听雨","rating":1000,"is_super_admin":false,"last_login":"2015-12-16T09:25:08.000Z","membership":{"access_level":"member","user_id":540,"group_id":7}},{"id":559,"username":"418193459@qq.com","password":"sha1$61eeb79d$1$142ee597793c07e54781cab0e771e0f606227a99","description":"","school":"北京航空航天大学","college":"计算机学院","student_id":"15061193","phone":"13121223393","nickname":"陈嘉林","rating":1000,"is_super_admin":false,"last_login":"2015-12-16T12:27:40.000Z","membership":{"access_level":"member","user_id":559,"group_id":7}},{"id":569,"username":"307985058@qq.com","password":"sha1$28350019$1$e6d640f573fe05d0501f582cfbdab6e9fab3f29c","description":null,"school":"北京航空航天大学","college":"-----","student_id":"14091002","phone":"13021250661","nickname":"张译尹","rating":1000,"is_super_admin":false,"last_login":"2015-12-18T18:24:25.000Z","membership":{"access_level":"member","user_id":569,"group_id":7}},{"id":575,"username":"503293944@qq.com","password":"sha1$4c30ebaa$1$edaa076cc32262bed1ce7cb2b4c7f5944247e8bb","description":"","school":"北京航空航天大学","college":"计算机学院","student_id":"15061140","phone":"18143370955","nickname":"刘智辉","rating":1000,"is_super_admin":false,"last_login":"2015-12-18T07:31:28.000Z","membership":{"access_level":"member","user_id":575,"group_id":7}},{"id":583,"username":"1099308682@qq.com","password":"sha1$7124ecf5$1$609d1e78b3016db44f8847e74ceca38dc76e35cc","description":"","school":"北京航空航天大学","college":"计算机学院","student_id":"14061118","phone":"13327829510","nickname":"朱瑾","rating":1000,"is_super_admin":false,"last_login":"2015-12-16T14:10:31.000Z","membership":{"access_level":"member","user_id":583,"group_id":7}},{"id":586,"username":"dy.octa@outlook.com","password":"sha1$a256482f$1$004a73fb011a5bab5834b8b4874b2569666d7f98","description":null,"school":"北京航空航天大学","college":"计算机学院","student_id":"15061170","phone":"15600608200","nickname":"贺牧天","rating":1000,"is_super_admin":false,"last_login":"2015-12-16T13:33:00.000Z","membership":{"access_level":"member","user_id":586,"group_id":7}},{"id":593,"username":"574380920@qq.com","password":"sha1$46b3702a$1$5bc10314f4099a7b0f423d7f8fefdc0be651aebe","description":"","school":"北京航空航天大学","college":"计算机学院","student_id":"15061201","phone":"15600532355","nickname":"林宁宁","rating":1000,"is_super_admin":false,"last_login":"2015-12-18T14:46:20.000Z","membership":{"access_level":"member","user_id":593,"group_id":7}},{"id":605,"username":"ericzhou@buaa.edu.cn","password":"sha1$9fde2877$1$78ee8336883328a768f29dfe47e36afb98555f29","description":null,"school":"北京航空航天大学","college":"-----","student_id":"14031247","phone":"13020005361","nickname":"周诗程","rating":1000,"is_super_admin":false,"last_login":"2015-12-19T05:17:35.000Z","membership":{"access_level":"member","user_id":605,"group_id":7}},{"id":634,"username":"752606159@qq.com","password":"sha1$b071f4ed$1$dc1895b933ca4691b6a990bd6c434843656c4b86","description":null,"school":"北京航空航天大学","college":"-----","student_id":"15131054","phone":"13121265937","nickname":"赵铠枫","rating":1000,"is_super_admin":false,"last_login":"2015-12-16T13:30:25.000Z","membership":{"access_level":"member","user_id":634,"group_id":7}},{"id":639,"username":"zyx_xiao@126.com","password":"sha1$0614c4e2$1$cd5b6c71eaac69fbac72646e88916528ea12e7e5","description":"yangjing","school":"北京航空航天大学","college":"软件学院","student_id":"14281103","phone":"13141214201","nickname":"张彦潇","rating":1000,"is_super_admin":false,"last_login":"2015-12-19T15:32:42.000Z","membership":{"access_level":"member","user_id":639,"group_id":7}},{"id":686,"username":"850074816@qq.com","password":"sha1$bbe20377$1$ede98d0370d3ecea543d109a1d22ca5d9d582e40","description":null,"school":"北京航空航天大学","college":"-----","student_id":"15101057","phone":"18810717855","nickname":"张乾宇","rating":1000,"is_super_admin":false,"last_login":"2015-12-17T17:08:04.000Z","membership":{"access_level":"member","user_id":686,"group_id":7}},{"id":718,"username":"mektpoy@gmail.com","password":"sha1$a22285c8$1$8c45c1f573530b0a7265ff437e49bacdff6e0bb0","description":"我是唐老师的忠实脑残粉！","school":"北京航空航天大学","college":"计算机学院","student_id":"","phone":"18959040920","nickname":"许翰翔","rating":1000,"is_super_admin":false,"last_login":"2015-12-18T00:30:01.000Z","membership":{"access_level":"member","user_id":718,"group_id":7}}]}
#    P = []
#    #console.log "HERE"
#    for user in group.users
#      if user.id is 1
#        continue
#      #console.log user
#      P.push(User.create({
#        username: user.username
#        password: user.password
#        nickname: user.nickname
#        description: user.description
#        student_id:user.student_id
#        phone: user.phone
#        school: "北京航空航天大学"
#        rating: user.rating
#      }))
#    db.Promise.all P
  .then ->
    users =
      [
        {school:"北京理工大学-计算机学院", nickname:"迟泽闻", username:"friend_1", password:"sha1$fe745f41$1$1179f8a080a75bd243764e66fc4832d2a2db55d0", description:"504-1"},
        {school:"北京理工大学-软件学院", nickname:"姜天洋", username:"friend_3", password:"sha1$fe745f41$1$1179f8a080a75bd243764e66fc4832d2a2db55d0", description:"504-3"},
        {school:"北京邮电大学", nickname:"李世昊", username:"friend_5", password:"sha1$fe745f41$1$1179f8a080a75bd243764e66fc4832d2a2db55d0", description:"504-5"},
        {school:"北京林业大学", nickname:"于浩源", username:"friend_7", password:"sha1$fe745f41$1$1179f8a080a75bd243764e66fc4832d2a2db55d0", description:"504-7"},
        {school:"北京理工大学-软件学院", nickname:"蔡晓帆", username:"friend_9", password:"sha1$fe745f41$1$1179f8a080a75bd243764e66fc4832d2a2db55d0", description:"504-9"},
        {school:"北京理工大学-软件学院", nickname:"黄少勤", username:"friend_11", password:"sha1$fe745f41$1$1179f8a080a75bd243764e66fc4832d2a2db55d0", description:"504-11"},
        {school:"北京邮电大学", nickname:"杨炫越", username:"friend_13", password:"sha1$fe745f41$1$1179f8a080a75bd243764e66fc4832d2a2db55d0", description:"504-13"},
        {school:"中国地质大学", nickname:"曲文天", username:"friend_15", password:"sha1$fe745f41$1$1179f8a080a75bd243764e66fc4832d2a2db55d0", description:"504-15"},
        {school:"中国地质大学", nickname:"朱质宁", username:"friend_17", password:"sha1$fe745f41$1$1179f8a080a75bd243764e66fc4832d2a2db55d0", description:"504-17"},
        {school:"北京理工大学-计算机学院", nickname:"黄轩成", username:"friend_19", password:"sha1$fe745f41$1$1179f8a080a75bd243764e66fc4832d2a2db55d0", description:"504-19"},
        {school:"中国地质大学", nickname:"邹卓君", username:"friend_21", password:"sha1$fe745f41$1$1179f8a080a75bd243764e66fc4832d2a2db55d0", description:"504-21"},
        {school:"中国地质大学", nickname:"高翔", username:"friend_23", password:"sha1$fe745f41$1$1179f8a080a75bd243764e66fc4832d2a2db55d0", description:"504-23"},
        {school:"中国地质大学", nickname:"申则宇", username:"friend_25", password:"sha1$fe745f41$1$1179f8a080a75bd243764e66fc4832d2a2db55d0", description:"504-25"},
        {school:"北京理工大学-计算机学院", nickname:"张大猷", username:"friend_27", password:"sha1$fe745f41$1$1179f8a080a75bd243764e66fc4832d2a2db55d0", description:"504-27"},
        {school:"北京科技大学", nickname:"陈笑天", username:"friend_29", password:"sha1$fe745f41$1$1179f8a080a75bd243764e66fc4832d2a2db55d0", description:"504-29"},
        {school:"北京林业大学", nickname:"易彰彪", username:"friend_31", password:"sha1$fe745f41$1$1179f8a080a75bd243764e66fc4832d2a2db55d0", description:"504-31"},
        {school:"中国地质大学", nickname:"赵嘉诚", username:"friend_33", password:"sha1$fe745f41$1$1179f8a080a75bd243764e66fc4832d2a2db55d0", description:"504-33"},
        {school:"中国地质大学", nickname:"张文慧", username:"friend_35", password:"sha1$fe745f41$1$1179f8a080a75bd243764e66fc4832d2a2db55d0", description:"504-35"},
        {school:"北京理工大学-软件学院", nickname:"罗艺康", username:"friend_37", password:"sha1$fe745f41$1$1179f8a080a75bd243764e66fc4832d2a2db55d0", description:"504-37"},
        {school:"中国地质大学", nickname:"焦帅玉", username:"friend_39", password:"sha1$fe745f41$1$1179f8a080a75bd243764e66fc4832d2a2db55d0", description:"504-39"},
        {school:"北京师范大学", nickname:"孙文琦", username:"friend_41", password:"sha1$fe745f41$1$1179f8a080a75bd243764e66fc4832d2a2db55d0", description:"504-41"},
        {school:"北京邮电大学", nickname:"杨清平", username:"friend_43", password:"sha1$fe745f41$1$1179f8a080a75bd243764e66fc4832d2a2db55d0", description:"504-43"},
        {school:"北京邮电大学", nickname:"刘润涛", username:"friend_45", password:"sha1$fe745f41$1$1179f8a080a75bd243764e66fc4832d2a2db55d0", description:"504-45"},
        {school:"北京交通大学", nickname:"张彦潇", username:"friend_47", password:"sha1$fe745f41$1$1179f8a080a75bd243764e66fc4832d2a2db55d0", description:"504-47"},
        {school:"中国地质大学", nickname:"门一凡", username:"friend_49", password:"sha1$fe745f41$1$1179f8a080a75bd243764e66fc4832d2a2db55d0", description:"504-49"},
        {school:"北京林业大学", nickname:"熊瑞麒", username:"friend_51", password:"sha1$fe745f41$1$1179f8a080a75bd243764e66fc4832d2a2db55d0", description:"504-51"},
        {school:"北京邮电大学", nickname:"任琪宇", username:"friend_53", password:"sha1$fe745f41$1$1179f8a080a75bd243764e66fc4832d2a2db55d0", description:"504-53"},
        {school:"北京师范大学", nickname:"曾耀辉", username:"friend_55", password:"sha1$fe745f41$1$1179f8a080a75bd243764e66fc4832d2a2db55d0", description:"504-55"},
        {school:"北京邮电大学", nickname:"张晓宇", username:"friend_57", password:"sha1$fe745f41$1$1179f8a080a75bd243764e66fc4832d2a2db55d0", description:"504-57"},
        {school:"北京林业大学", nickname:"贾梓健", username:"friend_59", password:"sha1$fe745f41$1$1179f8a080a75bd243764e66fc4832d2a2db55d0", description:"504-59"},
        {school:"北京邮电大学", nickname:"郝绍明", username:"friend_61", password:"sha1$fe745f41$1$1179f8a080a75bd243764e66fc4832d2a2db55d0", description:"504-61"},
        {school:"北京林业大学", nickname:"胡轶群", username:"friend_63", password:"sha1$fe745f41$1$1179f8a080a75bd243764e66fc4832d2a2db55d0", description:"504-63"},
        {school:"北京林业大学", nickname:"刘超懿", username:"friend_65", password:"sha1$fe745f41$1$1179f8a080a75bd243764e66fc4832d2a2db55d0", description:"504-65"},
        {school:"北京理工大学-软件学院", nickname:"颜苏卿", username:"friend_67", password:"sha1$fe745f41$1$1179f8a080a75bd243764e66fc4832d2a2db55d0", description:"504-67"},
        {school:"北京理工大学-软件学院", nickname:"段然杰", username:"friend_69", password:"sha1$fe745f41$1$1179f8a080a75bd243764e66fc4832d2a2db55d0", description:"504-69"},
        {school:"北京理工大学-计算机学院", nickname:"张世强", username:"friend_71", password:"sha1$fe745f41$1$1179f8a080a75bd243764e66fc4832d2a2db55d0", description:"504-71"},
        {school:"北京邮电大学", nickname:"崔颢", username:"friend_73", password:"sha1$fe745f41$1$1179f8a080a75bd243764e66fc4832d2a2db55d0", description:"504-73"},
        {school:"北京邮电大学", nickname:"李松远", username:"friend_75", password:"sha1$fe745f41$1$1179f8a080a75bd243764e66fc4832d2a2db55d0", description:"504-75"},
        {school:"北京师范大学", nickname:"卜凡", username:"friend_77", password:"sha1$fe745f41$1$1179f8a080a75bd243764e66fc4832d2a2db55d0", description:"504-77"},
        {school:"北京邮电大学", nickname:"刘玉栋", username:"friend_79", password:"sha1$fe745f41$1$1179f8a080a75bd243764e66fc4832d2a2db55d0", description:"504-79"}
    ]

    P = []
    #console.log "HERE"
    for user in users
      #console.log user
      P.push(User.create({
        username: user.username
        password: user.password
        nickname: user.nickname
        description: user.description
        #student_id:user.student_id
        #phone: user.phone
        school: user.school
        #rating: user.rating
      }))
    db.Promise.all P
  .then ->
    console.log "Success"
#    User.create {
#      username: "test@test.com"
#      password: 'sha1$32f5d6c9$1$c84e8c6ed82e32549513da9444d940599ad30b96'
#      nickname: 'test'
#    }
#  .then (user)-> #create groups
#    testUser = user
#    for i in [0..100]
#      Group
#        .create {
#            name: "test_group_private#{i}"
#            description: 'This group is created for testing private.'
#            access_level: 'private'
#          }
#        .then (group)->
#          group.setCreator(testUser)
#        .then (group) ->
#          group.addUser(testUser, {access_level : 'owner'}) #添加owner关系
#    Group
#      .create {
#        name: 'test_group_verifying'
#        description: 'This group is created for testing verifying.'
#        access_level: 'verifying'
#      }
#      .then (group)->
#        group.setCreator(testUser)
#      .then (group) ->
#        group.addUser(testUser, {access_level : 'owner'}) #添加owner关系
#    Group
#      .create {
#        name: 'test_group'
#        description: 'This group is created for testing.'
#        access_level: 'protect'
#      }
#      .then (group)->
#        testGroup = group
#        group.setCreator(testUser)
#      .then (group) ->
#        group.addUser(testUser, {access_level : 'owner'}) #添加owner关系
#  .then ->
#    for i in [0..100]
#      User
#        .create {
#          username: "test#{i}@test.com"
#          password: 'sha1$32f5d6c9$1$c84e8c6ed82e32549513da9444d940599ad30b96'
#          nickname: "test#{i}"
#        }
#        .then (user)->
#          testGroup.addUser(user,{access_level : 'member'})
#    Problem
#      .create {
#        title: 'test_problem_public'
#        access_level: 'public'
#      }
#      .then (problem)->
#        testProblem = problem
#        testUser.addProblem(problem)
#        testGroup.addProblem(problem)
#  .then ->
#    Problem
#      .create {
#        title: 'test_problem'
#        access_level: 'private'
#      }
#      .then (problem)->
#        testUser.addProblem(problem)
#        testGroup.addProblem(problem)
#  .then ->
#    for i in [0..100]
#      Problem
#      .create {
#        title: "test_problem_protect#{i}"
#        access_level: 'protect'
#      }
#      .then (problem)->
#        testUser.addProblem(problem)
#        testGroup.addProblem(problem)
#  .then ->
#    for i in [0..100]
#      Contest
#        .create {
#          title: "test_contest_private#{i}"
#          access_level: 'private'
#          description: '用来测试的比赛，权限是private'
#          start_time : new Date("2015-05-20 10:00")
#          end_time : new Date("2015-05-21 10:00")
#        }
#        .then (contest)->
#          testUser.addContest(contest)
#          testGroup.addContest(contest)
#    db.Promise.all [
#      Contest
#        .create {
#          title: 'test_contest_private'
#          access_level: 'private'
#          description: '用来测试的比赛，权限是private'
#          start_time : new Date("2015-05-20 10:00")
#          end_time : new Date("2015-05-21 10:00")
#        }
#        .then (contest)->
#          testUser.addContest(contest)
#          testGroup.addContest(contest)
#    ,
#      Contest
#        .create {
#          title: 'test_contest_public'
#          access_level: 'public'
#          description: '用来测试的比赛，权限是public'
#          start_time : new Date("2016-05-20 10:00")
#          end_time : new Date("2016-09-21 10:00")
#        }
#        .then (contest)->
#          testUser.addContest(contest)
#          testGroup.addContest(contest)
#    ,
#      Contest
#        .create {
#          title: 'test_contest'
#          access_level: 'protect'
#          description: '用来测试的比赛，权限是protect'
#          start_time : new Date("2015-05-21 10:00")
#          end_time : new Date("2015-06-21 10:00")
#        }
#        .then (contest)->
#          testUser.addContest(contest)
#          testGroup.addContest(contest)
#          contest.addProblem(testProblem, {
#            order : 0
#            score : 1
#          })
#    ]
#  .then ->
#    db.Promise.all [
#      Judge.create {
#        name : "Judge1"
#        secret_key : "沛神太帅了"
#      }
#    ,
#      Judge.create {
#        name : "Judge2"
#        secret_key : "梁明阳专用judge"
#      }
#    ]
#  .then ->
#    for i in [0..100]
#      Submission.create(
#        result : 'AC'
#      ).then (submission)->
#        submission.setCreator(testUser)
#        testUser.addSubmission(submission)
#        testProblem.addSubmission(submission)
#    return undefined
#  .then ->
#    console.log "init ok!"