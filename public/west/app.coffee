angular.module('west', [
  'ui.bootstrap',
  'west-router'
])

.filter('richtext', ['$sce', ($sce)->
  (html)->
    $sce.trustAsHtml(html)
])
.controller('main', ($scope, $timeout, $routeParams)->
  $scope.$routeParams = $routeParams

  $scope.now = new Date()
  update = ()->
    $scope.now = new Date()
    $timeout(update, 1000)
  update()

  $scope.slides = [
    image: "images/news/img1.jpg"
    url: 'http://www.chinawestern.org/newsread.asp?NewsID=6272'
    text: "医疗扶贫项目正式签约"
  ,
    image: "images/news/img2.jpg"
    url: 'http://www.chinawestern.org/newsread.asp?NewsID=6269'
    text: "中国西部发展促进会慰问驻云南边防官兵"
  ]
  $scope.news_list = [
    title: '《“健康中国2020”战略研究报告》摘要'
    content: '''<h1 style="text-align: center;"><strong>《&ldquo;健康中国</strong><strong>2020&rdquo;战略研究报告》摘要</strong></h1>
    <p style="text-align: center;">中华人民共和国国家卫生和计划生育委员会&nbsp;&nbsp;&nbsp;&nbsp;www.moh.gov.cn&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2012-08-20</p>

    <p>　　</p>

    <p>健康是人全面发展的基础，党的十七大将人人享有基本医疗卫生服务确立为全面建设小康社会的新要求之一。围绕十七大提出的目标，以深化医药卫生体制改革为动力，卫生部组织数百名专家开展了&ldquo;健康中国2020&rdquo;&nbsp;战略研究，针对发展我国卫生事业和改善人民健康具有战略性、全局性、前瞻性的重大问题进行深入研究，最终形成&ldquo;健康中国2020&rdquo;战略研究报告。报告分析了实现2020年国民健康发展所面临的机遇与挑战，提出了发展目标、战略重点、行动计划及政策措施。</p>

    <p><strong>一、机遇与挑战</strong></p>

    <p>（一）建设小康社会的目标和经济社会转型对保障国民健康提出更高要求。人人享有基本医疗卫生服务，提高全民健康水平，是全面建设小康社会的重要目标。同时，我国经济社会转型中呈现的快速全球化、工业化、城镇化、人口老龄化和生活方式变化，不但使食品药品安全、饮水安全、职业安全和环境问题成为重大健康危险因素，而且使国民同时面临重大传染病和慢性非传染性疾病的双重威胁，对保障国民健康带来新的压力。</p>

    <p>（二）居民健康状况仍需改善，不同人群之间差异显著。虽然我国人均预期寿命已由建国初期的35岁提高到2005年的73岁，但不同地域和人群间的健康差异较为显著，东西部省份人均预期寿命相差最大者达15岁。卫生资源配置不均衡，每千人医师数和病床数、人均医疗支出等指标因各地经济社会发展水平不同而有所差异。</p>

    <p>（三）疾病发病和死亡模式转变，城乡居民疾病负担沉重。随着经济社会快速变化，我国绝大部分地区已经完成了疾病发病、死亡模式的转变。当前，我们既面临发达国家的健康问题，也存在着发展中国家的疾病和健康问题，疾病负担日益加重，已经成为社会和经济发展的沉重包袱，而其中以重大慢性病造成的疾病负担最为严重。</p>

    <p>（四）重大健康问题依然突出。目前病毒性肝炎、结核、艾滋病等患病率仍呈上升趋势，成为我国传染病防控所面临的突出问题。同时，慢性病患病率和死亡率不断上升，重大地方病与其它感染性疾病尚未得到有效控制，母婴疾病与营养不良不容忽视，食品、药品安全等问题日益显现，严重威胁人民群众的身体健康和生命安全。</p>

    <p>（五）健康危险因素的影响持续扩大。目前，烟草使用、身体活动不足、膳食不合理、过量饮酒等不健康生活方式与行为在我国处于流行高水平或呈进行性上升趋势。同时，环境污染加重也对健康带来严重危害。</p>

    <p>（六）医疗卫生服务供给与人民健康需求之间仍有较大差距。随着经济持续快速增长，人民群众的健康需求越来越高，但我国卫生资源总量仍然不足，结构不合理，卫生服务的公平性和可及性仍然较差，是构建和谐社会的严峻挑战。</p>

    <p>（七）相关公共政策不适应我国健康状况快速转型的需要。公共卫生、医疗服务和药物政策在制定、调整等方面滞后甚或缺如，执行力度也不够，难以适应我国健康状况转型的需要。</p>

    <p>（八）医药科技进步为促进国民健康提供有力手段。新方法、新药品、新仪器、新设备的发明创造和快速推广应用，使得疾病预防、诊疗水平显著提高，为卫生事业发展提供了重要机遇。</p>

    <p>（九）深化医药卫生体制改革为实现国民健康目标奠定制度基础。不断深入的医药卫生体制改革是建设社会主义现代化国家的必然要求，为我国卫生事业发展解决了基本制度安排问题，为实现2020年国民健康目标奠定了坚实的基础。</p>

    <p><strong>二、目标</strong></p>

    <p>研究提出的&ldquo;健康中国2020&rdquo;总目标是：改善城乡居民健康状况，提高国民健康生活质量，减少不同地区健康状况差异，主要健康指标基本达到中等发达国家水平。到2015年，基本医疗卫生制度初步建立，使全体国民人人拥有基本医疗保障、人人享有基本公共卫生服务，医疗卫生服务可及性明显增强，地区间人群健康状况和资源配置差异明显缩小，国民健康水平居于发展中国家前列。到2020年，完善覆盖城乡居民的基本医疗卫生制度，实现人人享有基本医疗卫生服务，医疗保障水平不断提高，卫生服务利用明显改善，地区间人群健康差异进一步缩小，国民健康水平达到中等发达国家水平。</p>

    <p><strong>三、战略重点与行动计划</strong></p>

    <p>依据危害的严重性、影响的广泛性、有较为明确的干预措施、公平性和前瞻性等筛选原则，研究提出了针对重点人群、重大疾病与健康问题、可控健康危险因素的3类10项战略重点与优先领域。具体包括：促进生殖健康，预防出生缺陷，确保母婴平安；改善工作环境，降低职业危害，促进职业人群健康；改善贫困地区和贫困人群健康，缩小健康差异；健全服务体系，完善保健康复，实现健康老龄化；重大和新发传染病防控；重大慢性病与伤害防控；发展生物科技，提高遗传诊断水平；多部门合作，改善生活和工作环境；促进健康教育，倡导健康生活方式；加强卫生服务体系和能力建设，改善服务质量。</p>

    <p>针对优先领域，研究提出了以下4类21项行动计划：</p>

    <p>（一）针对重点人群的行动计划。<strong>母婴健康行动计划</strong>，通过推广婚前医学检查、普及生殖保健服务、提供出生缺陷防治服务、提高孕产妇孕期保健和住院分娩比例、提供7岁以下儿童免费保健服务等措施，降低出生缺陷、确保母婴平安、提高妇女儿童生命质量和健康水平。<strong>改善贫困地区人群健康行动计划</strong>，通过采取倾斜性政策，设立专项，最大程度地缩小与贫困有关健康问题的城乡差距。<strong>职业健康行动计划</strong>，通过改善工作环境、劳动条件和职业病患者生活质量，促进劳动力人口的健康，延长职业病患者寿命，到2020年，职业健康监护率由10%增至50%，职业中毒事故发生率、职业中毒事故死亡率分别下降50%和30%。</p>

    <p>（二）针对重大疾病的行动计划。<strong>重点传染病控制行动计划</strong>，全面实施扩大国家免疫规划，针对艾滋病、结核病、病毒性肝炎、血吸虫病、人畜共患病等重点或新发传染病、地方病采取干预措施，有效遏制和降低这些疾病的健康危害。<strong>重点慢性病防控行动计划</strong>，通过设立心脑血管病控制、重要恶性肿瘤早期发现、糖尿病控制等专项，遏制慢性疾病的高发病率、高患病率和高死亡率，减少慢性病导致的失能、致残、早逝和沉重的疾病负担。<strong>伤害监测和干预行动计划</strong>，通过伤害综合监测，及时向社会预警伤害高危因素，指导开展儿童伤害干预活动，降低18岁以下人群伤害死亡率。</p>

    <p>（三）针对健康危险因素的行动计划。<strong>环境与健康行动计划</strong>，提高饮用水安全水平、无害化卫生厕所普及率以及固体废弃物处置比例，改善环境卫生，开展环境污染健康风险评估。<strong>食品安全行动计划</strong>，加强食源性疾病监测、溯源、预警和控制，健全食品污染物监测体系，加强食品安全风险识别、评估能力，构建国家权威的食品安全信息收集、整理、分析和风险预警交流平台，强化食品安全标准建设和突发性食品安全事件应急处理。<strong>全民健康生活方式行动计划</strong>，创造支持性政策环境，倡导多部门参与合作，通过在社区、学校、工作场所等开展一系列行动，提高全民健康意识、健康素养和健康生活方式行为能力，控制慢性病相关危险因素流行。<strong>减少烟草危害行动计划</strong>，通过建立完整的烟草控制监测体系、预防被动吸烟、提供戒烟服务、公众教育等措施，降低烟草流行率。</p>

    <p>（四）促进卫生发展、实现&ldquo;病有所医&rdquo;的行动计划。<strong>医疗卫生服务体系建设行动计划</strong>，明确政府卫生投入责任，重点加强基层卫生服务体系和县级医院建设，建立科学合理的公立医院服务体系，加快推进多元化办医。<strong>卫生人力资源建设行动计划</strong>，制定国家卫生人力发展规划，注重全科医生、乡村医生、公共卫生医师、注册护士、卫生科技人才和管理人才的培养。<strong>强化基本医疗保险制度建设、建立可持续性筹资机制行动计划，</strong>建立和完善覆盖城乡居民的多层次医疗保障体系，不断提高保障水平，逐步缩小城乡、地区间保障水平差距，逐步健全不同层次、不同水平的医疗保障体系。<strong>完善药品供应保障体系、促进合理用药行动计划，</strong>建立完善以国家基本药物制度为基础的药品供应保障体系，建立健全临床合理用药管理与监督系统，规范医务人员临床用药行为。<strong>规范服务行为、保障医疗安全行动计划</strong>，全面推行医疗诊疗规范、实施临床路径，规范医院内部安全管理，进一步加强医疗质量安全监管。<strong>控制医疗费用、提高医疗服务效率行动计划，</strong>完善医疗机构经济补偿政策，规范、合理确定医疗服务价格，鼓励医疗机构使用质优价廉药品，探索医院收付费方式改革。<strong>公共安全和卫生应急行动计划</strong>，建立灾害卫生应急救援体系，加强新发再发传染病和突发公共事件应急处置能力建设，完善医疗机构的公共卫生管理职能。<strong>推动科技创新行动计划</strong>，实施科技创新专项，加强转化整合医学能力建设，加强重大疾病和伤害防治研究和推广，实施城市社区和农村医疗卫生服务科技行动。<strong>国家健康信息系统行动计划</strong>，制订和实施国家卫生信息化发展纲要，落实医改方案对卫生信息化建设的要求，逐步建立统一高效、系统整合、互联互通、信息共享的国家卫生信息系统。<strong>中医药等我国传统医学行动计划，</strong>制定和实施国家传统医学政策和规划，建立稳定增长的中医药投入保障机制，加强中药资源保护和管理、中医优势病种研究和应用、传统医学和西医之间的互动，推广中医适宜技术。<strong>发展健康产业行动计划</strong>，建立以基本药械制度为核心的国家药械政策框架，加强监管，完善药品价格管理体系制，重点扶持自主研发药品、医用耗材、医疗器械和大型医疗仪器，以及与健康生活方式相关的健康产业。</p>

    <p><strong>四、政策措施</strong></p>

    <p>（一）建立促进国民健康的行政管理体制。组建&ldquo;健康与社会福利部&rdquo;或&ldquo;卫生与人类发展部&rdquo;，将卫生、健康与社会福利事务整合、形成医疗保障与服务统筹的、一体化的&ldquo;大卫生&rdquo;行政管理体制。健全卫生决策的咨询和问责机制。将健康指标纳入绩效考核，建立&ldquo;健康影响综合评价&rdquo;制度。加强和巩固基层卫生行政管理能力，确保卫生政策措施的落实。</p>

    <p>（二）健全卫生法律体系，依法行政。加快《基本医疗卫生保健法》的制订，科学设计和逐步完善医疗保障、促进国民健康的法律法规体系。加强卫生执法监督体系建设，形成权责明确、责任落实、行为规范、监督有效、保障有力的卫生执法体制。</p>

    <p>（三）适应国民健康需要，转变卫生事业发展模式。转变发展观念，推进&ldquo;环境友好型&rdquo;、&ldquo;健康促进型&rdquo;社会发展模式的建立。适应医学模式转变，推动建立促进国民健康的卫生事业发展模式。</p>

    <p>（四）建立与经济社会发展水平相适应的稳定的公共财政投入政策与机制。合理调整卫生总费用结构，通过增加政府卫生投入和社会筹资，将个人卫生支出降低到30%以内。建立卫生投入监督和评价机制，提高卫生投入配置和利用效率。建立合理的中央与地方分担机制，提高政府卫生投入的效益和可持续性。</p>

    <p>（五）统筹医疗保障制度发展。加快基本医疗保障制度建设，积极探索、有序推进城乡居民医保的制度统一和管理统一，进一步降低成本，提高效率，适应现代医学模式，从分担疾病风险向促进健康转变。巩固和发展新型农村合作医疗制度，大力鼓励社会力量举办补充医疗保险和商业医疗保险。</p>

    <p>（六）实施&ldquo;人才强卫&rdquo;战略，提高卫生人力素质。建立以政府为主导的医药卫生人才发展投入机制，优先保证对人才发展的投入。大力推动医学教育改革，增加医学教育投入和质量评估管理，通过准入制度的建立，改善和保证医学教育质量。完善各类卫生专业技术人才评价标准，拓宽卫生人才评价渠道，改进卫生人才评价方式。加强政府对医药卫生人才流动的政策引导，推动医药卫生人才向基层流动，加大西部地区人才培养与引进力度。</p>

    <p>（七）充分发挥中医药等我国传统医学优势。建立中医药传承和发展专项基金。加强中医药继承与创新。推广中医适宜技术，发挥其在疾病预防、基层医疗保障及医学模式转变过程中的作用。扶持民族医药产业发展。将有中国特色的健康文化理念融入精神文明建设。</p>

    <p>（八）积极开展国际交流与合作。根据我国健康领域的实际需要，深入研究各国情况，制定和实施针对不同国家的多层次、多渠道合作战略和政策，提升卫生援外工作层次，发挥国际影响力，促进全球健康。</p>

    <p>&nbsp;</p>

    <p style="text-align:right">&nbsp;</p>
    '''
    creator: '中华人民共和国国家卫生和计划生育委员会'
    created_at: '2012-08-20 07:11'
    updated_at: '2016-01-04 07:11'
  ,
    title: '《“健康中国2020”战略研究报告》解读 '
    content: '''<h1 style="text-align: center;">《&ldquo;健康中国2020&rdquo;战略研究报告》解读</h1>
    <p>　　一、&ldquo;健康中国2020&rdquo;战略研究提出了&ldquo;健康中国&rdquo;这一重大战略思想，这一思想的具体涵义是什么？有什么重要意义？</p>

    <p>　　&ldquo;健康中国&rdquo;战略是一项旨在全面提高全民健康水平的国家战略，是在准确判断世界和中国卫生改革发展大势的基础上，在深化医药卫生体制改革实践中形成的一项需求牵引型的国民健康发展战略。 &ldquo;健康中国&rdquo;战略思想的提出，是科学发展观在国民健康领域的具体体现，是卫生系统探索中国特色卫生改革发展道路集体智慧的结晶，是卫生战线对中国特色卫生事业发展理论体系的丰富发展。</p>

    <p>　　&ldquo;健康中国2020&rdquo;战略是以科学发展观为指导，以全面维护和增进人民健康，提高健康公平，实现社会经济与人民健康协调发展为目标，以公共政策为落脚点，以重大专项、重大工程为切入点的国家战略。实施&ldquo;健康中国2020&rdquo;战略，是构建和谐社会的重要基础性工程，有利于全面改善国民健康，确保医改成果为人民共享，也有利于促进经济发展方式转变，充分体现贯彻落实科学发展观的根本要求。</p>

    <p>　　二、&ldquo;健康中国2020&rdquo;战略研究对卫生事业发展所应遵循的指导思想与原则有怎样的考虑？</p>

    <p>　　关于卫生事业发展的指导思想，&ldquo;健康中国2020&rdquo;战略研究提出，卫生事业发展要以邓小平理论和&ldquo;三个代表&rdquo;重要思想为指导，深入贯彻落实科学发展观，把健康摆在优先发展的战略地位，将&ldquo;健康强国&rdquo;作为一项基本国策；坚持以人为本，以社会需求为导向，把维护人民健康权益放在第一位，以全面促进人民健康，提高健康的公平性，实现社会经济与人民健康协调发展为出发点和落脚点；强调&ldquo;预防为主&rdquo;，实现医学模式的根本转变，以公共政策、科技进步、中西医结合、重大行动为切入点，着力解决长期（或长远）威胁我国人民生命安全的重大疾病和健康问题；实施综合治理，有机协调部门职能，充分调动各方面积极性，共同应对卫生挑战，实现&ldquo;健康中国，多方共建，全民共享&rdquo;。</p>

    <p>　　关于卫生事业发展的基本原则，&ldquo;健康中国2020&rdquo;战略研究提出，卫生事业发展要坚持以下四个方面的原则，一是坚持把&ldquo;人人健康&rdquo;纳入经济社会发展规划目标，二是坚持公平效率统一，注重政府责任与市场机制相结合，三是坚持统筹兼顾，突出重点，增强卫生发展的整体性和协调性，四是坚持预防为主，适应并推动医学模式转变。</p>

    <p>　　三、&ldquo;健康中国2020&rdquo;战略研究提出&ldquo;到2020年，主要健康指标基本达到中等发达国家水平&rdquo;，具体包括哪些目标？</p>

    <p>　　为实现卫生事业与国民健康的发展目标，&ldquo;健康中国2020&rdquo;战略研究构建了一个体现科学发展观的卫生发展综合目标体系，将总体目标分解为可操作、可测量的10个具体目标和95个分目标。这些目标涵盖了保护和促进国民健康的服务体系及其支撑保障条件，是监测和评估国民健康状况、有效调控卫生事业运行的重要依据。</p>

    <p>　　10个具体目标是：国民主要健康指标进一步改善，到2020年，人均预期寿命达到77岁，5岁以下儿童死亡率下降到13&permil;，孕产妇死亡率降低到20/10万，减少地区间健康状况的差距；完善卫生服务体系，提高卫生服务可及性和公平性；健全医疗保障制度，减少居民疾病经济风险；控制危险因素，遏止、扭转和减少慢性病的蔓延和健康危害；强化传染病和地方病防控，降低感染性疾病危害；加强监测与监管，保障食品药品安全；依靠科技进步，适应医学模式的转变，实现重点前移、转化整合战略；继承创新中医药，发挥中医药等我国传统医学在保障国民健康中的作用；发展健康产业，满足多层次、多样化卫生服务需求；履行政府职责，加大健康投入，到2020年，卫生总费用占GDP的比重达到6.5%～7%，保障&ldquo;健康中国2020&rdquo; 战略目标实现。</p>

    <p>　　四、&ldquo;健康中国2020&rdquo;战略研究提出的今后一个时期卫生工作的战略重点是什么？</p>

    <p>　　&ldquo;健康中国2020&rdquo;战略研究依据危害的严重性、影响的广泛性、明确的干预措施、公平性及前瞻性的原则，筛选出了针对重点人群、重大疾病及可控健康危险因素的三类优先领域，并进一步提出了分别针对上述三类优先领域以及实现&ldquo;病有所医&rdquo;可采取的21项行动计划作为今后一个时期的重点任务，包括针对重点人群的母婴健康行动计划、改善贫困地区人群健康行动计划、职业健康行动计划；针对重大疾病的重点传染病控制行动计划、重点慢性病防控行动计划、伤害监测和干预行动计划；针对健康危险因素的环境与健康行动计划、食品安全行动计划、全民健康生活方式行动计划、减少烟草危害行动计划；促进卫生发展，实现&ldquo;病有所医&rdquo;的医疗卫生服务体系建设行动计划、卫生人力资源建设行动计划、强化基本医疗保险制度行动计划、促进合理用药行动计划、保障医疗安全行动计划、提高医疗卫生服务效率行动计划、公共安全和卫生应急行动计划、推动科技创新计划、国家健康信息系统行动计划、中医药等我国传统医学行动计划、发展健康产业行动计划。</p>

    <p>　　五、为保障各项指标的实现，&ldquo;健康中国2020&rdquo;战略研究在政策措施方面提出了哪些建议？</p>

    <p>　　健康中国2020&rdquo;战略研究提出了推动卫生事业发展的8项政策措施。一是建立促进国民健康的行政管理体制，形成医疗保障与服务统筹一体化的&ldquo;大卫生&rdquo;行政管理体制；二是健全法律支撑体系，依法行政；三是适应国民健康需要，转变卫生事业发展模式，从注重疾病诊疗向预防为主、防治结合转变，实现关口前移；四是建立与经济社会发展水平相适应的公共财政投入政策与机制，通过增加政府卫生投入和社会统筹，将个人现金卫生支出降低到30%以内；五是统筹保障制度发展，提高基本医疗保险筹资标准和补偿比例，有序推进城乡居民医保制度统一、管理统一；六是实施&ldquo;人才强卫&rdquo;战略，提高卫生人力素质；七是充分发挥中医药等我国传统医学优势，促进中医药继承和创新；八是积极开展国际交流与合作。</p>

    <p>&nbsp;</p>

    <p style="text-align:right">&nbsp;</p>

    '''
    creator: '西促会健康中国促进会'
    created_at: '2016-01-02 23:33'
    updated_at: '2016-01-03 07:11'
  ,
    title: '中国国务院 关于打赢脱贫攻坚战的决定'
    content: '''
    <p><strong>学习资料</strong></p>

    <p style="text-align: center;">中共中央国务院</p>

    <h1 style="text-align: center;">关于打赢脱贫攻坚战的决定</h1>

    <p>&nbsp;</p>

    <p style="text-align: center;">2015年11月29日</p>

    <p>&nbsp;</p>

    <p>确保到2020年农村贫困人口实现脱贫，是全面建成小康社会最艰巨的任务。现就打赢脱贫攻坚战作出如下决定。</p>

    <p>一、增强打赢脱贫攻坚战的使命感紧迫感</p>

    <p>消除贫困、改善民生、逐步实现共同富裕，是社会主义的本质要求，是我们党的重要使命。改革开放以来，我们实施大规模扶贫开发，使7亿农村贫困人口摆脱贫困，取得了举世瞩目的伟大成就，谱写了人类反贫困历史上的辉煌篇章。党的十八大以来，我们把扶贫开发工作纳入&ldquo;四个全面&rdquo;战略布局，作为实现第一个百年奋斗目标的重点工作，摆在更加突出的位置，大力实施精准扶贫，不断丰富和拓展中国特色扶贫开发道路，不断开创扶贫开发事业新局面。</p>

    <p>我国扶贫开发<u>已进入啃硬骨头、攻坚拔寨的冲刺期</u>。中西部一些省（自治区、直辖市）贫困人口规模依然较大，剩下的贫困人口贫困程度较深，减贫成本更高，脱贫难度更大。实现到2020年让7000多万农村贫困人口摆脱贫困的既定目标，时间十分紧迫、任务相当繁重。必须在现有基础上不断创新扶贫开发思路和办法，<u>坚决打赢这场攻坚战</u>。</p>

    <p>扶贫开发事关全面建成小康社会，事关人民福祉，事关巩固党的执政基础，事关国家长治久安，事关我国国际形象。打赢脱贫攻坚战，是促进全体人民共享改革发展成果、实现共同富裕的重大举措，是体现中国特色社会主义制度优越性的重要标志，也是经济发展新常态下扩大国内需求、促进经济增长的重要途径。各级党委和政府<u>必须把扶贫开发工作作为重大政治任务来抓</u>，切实增强责任感、使命感和紧迫感，切实解决好思想认识不到位、体制机制不健全、工作措施不落实等突出问题，不辱使命、勇于担当，只争朝夕、真抓实干，<u>加快补齐全面建成小康社会中的这块突出短板，决不让一个地区、一个民族掉队</u>，实现《中共中央关于制定国民经济和社会发展第十三个五年规划的建议》确定的脱贫攻坚目标。</p>

    <p>二、打赢脱贫攻坚战的总体要求</p>

    <p><strong>（一）指导思想</strong></p>

    <p>全面贯彻落实党的十八大和十八届二中、三中、四中、五中全会精神，以邓小平理论、&ldquo;三个代表&rdquo;重要思想、科学发展观为指导，深入贯彻习近平总书记系列重要讲话精神，围绕&ldquo;四个全面&rdquo;战略布局，牢固树立并切实贯彻创新、协调、绿色、开放、共享的发展理念，充分发挥政治优势和制度优势，<u>把精准扶贫、精准脱贫作为基本方略</u>，<strong>坚持</strong>扶贫开发与经济社会发展相互促进，<strong>坚持</strong>精准帮扶与集中连片特殊困难地区开发紧密结合，<strong>坚持</strong>扶贫开发与生态保护并重，<strong>坚持</strong>扶贫开发与社会保障有效衔接，咬定青山不放松，采取超常规举措，拿出过硬办法，举全党全社会之力，坚决打赢脱贫攻坚战。</p>

    <p><strong>（二）总体目标</strong></p>

    <p><u>到</u><u>2020</u><u>年，</u>稳定实现农村贫困人口<u>不愁吃、不愁穿，义务教育、基本医疗和住房安全有保障</u>。实现贫困地区<u>农民人均可支配收入增长幅度高于全国平均水平</u>，<u>基本公共服务主要领域指标接近全国平均水平</u>。确保我国<u>现行标准下农村贫困人口实现脱贫</u>，<u>贫困县全部摘帽</u>，<u>解决区域性整体贫困</u>。</p>

    <p><strong>（三）基本原则</strong></p>

    <p>&mdash;&mdash;<u>坚持党的领导，夯实组织基础</u>。充分发挥各级党委总揽全局、协调各方的领导核心作用，严格执行脱贫攻坚一把手负责制，省市县乡村五级书记一起抓。切实加强贫困地区农村基层党组织建设，使其成为带领群众脱贫致富的坚强战斗堡垒。</p>

    <p>&mdash;&mdash;<u>坚持政府主导，增强社会合力</u>。强化政府责任，引领市场、社会协同发力，鼓励先富帮后富，构建专项扶贫、行业扶贫、社会扶贫互为补充的大扶贫格局。</p>

    <p>&mdash;&mdash;<u>坚持精准扶贫，提高扶贫成效</u>。扶贫开发贵在精准，重在精准，必须解决好扶持谁、谁来扶、怎么扶的问题，做到扶真贫、真扶贫、真脱贫，切实提高扶贫成果可持续性，让贫困人口有更多的获得感。</p>

    <p>&mdash;&mdash;<u>坚持保护生态，实现绿色发展</u>。牢固树立绿水青山就是金山银山的理念，把生态保护放在优先位置，扶贫开发不能以牺牲生态为代价，探索生态脱贫新路子，让贫困人口从生态建设与修复中得到更多实惠。</p>

    <p>&mdash;&mdash;<u>坚持群众主体，激发内生动力</u>。继续推进开发式扶贫，处理好国家、社会帮扶和自身努力的关系，发扬自力更生、艰苦奋斗、勤劳致富精神，充分调动贫困地区干部群众积极性和创造性，注重扶贫先扶智，增强贫困人口自我发展能力。</p>

    <p>&mdash;&mdash;<u>坚持因地制宜，创新体制机制</u>。突出问题导向，创新扶贫开发路径，由&ldquo;大水漫灌&rdquo;向&ldquo;精准滴灌&rdquo;转变；创新扶贫资源使用方式，由多头分散向统筹集中转变；创新扶贫开发模式，由偏重&ldquo;输血&rdquo;向注重&ldquo;造血&rdquo;转变；创新扶贫考评体系，由侧重考核地区生产总值向主要考核脱贫成效转变。</p>

    <p>三、实施精准扶贫方略，加快贫困人口精准脱贫</p>

    <p><strong>（四）健全精准扶贫工作机制。</strong>抓好<u>精准识别、建档立卡</u>这个关键环节，为打赢脱贫攻坚战打好基础，为推进城乡发展一体化、逐步实现基本公共服务均等化创造条件。按照<u>扶持对象精准</u>、<u>项目安排精准</u>、<u>资金使用精准</u>、<u>措施到户精准</u>、<u>因村派人精准</u>、<u>脱贫成效精准</u>的要求，使建档立卡贫困人口中有<u>5000</u><u>万人左右通过产业扶持、转移就业、易地搬迁、教育支持、医疗救助等措施实现脱贫</u>，其余<u>完全或部分丧失劳动能力的贫困人口实行社保政策兜底脱贫</u>。对建档立卡贫困村、贫困户和贫困人口定期进行全面核查，建立精准扶贫台账，实行有进有出的动态管理。根据致贫原因和脱贫需求，对贫困人口实行分类扶持。建立贫困户脱贫认定机制，对<u>已经脱贫的农户，在一定时期内让其继续享受扶贫相关政策</u>，避免出现边脱贫、边返贫现象，切实做到应进则进、应扶则扶。抓紧制定严格、规范、透明的国家扶贫开发工作重点县退出标准、程序、核查办法。重点县退出，由县提出申请，市（地）初审，省级审定，报国务院扶贫开发领导小组备案。<u>重点县退出后，在攻坚期内国家原有扶贫政策保持不变</u>，抓紧制定攻坚期后国家帮扶政策。加强对扶贫工作绩效的社会监督，开展贫困地区群众扶贫满意度调查，建立对扶贫政策落实情况和扶贫成效的第三方评估机制。评价精准扶贫成效，既要看减贫数量，更要看脱贫质量，不提不切实际的指标，对弄虚作假搞&ldquo;数字脱贫&rdquo;的，要严肃追究责任。</p>

    <p><strong>（五）发展特色产业脱贫。</strong>制定贫困地区特色产业发展规划。出台专项政策，统筹使用涉农资金，重点支持贫困村、贫困户因地制宜发展种养业和传统手工业等。<u>实施贫困村&ldquo;一村一品&rdquo;产业推进行动</u>，<u>扶持建设一批贫困人口参与度高的特色农业基地</u>。加强贫困地区农民合作社和龙头企业培育，发挥其对贫困人口的组织和带动作用，强化其与贫困户的利益联结机制。<u>支持贫困地区发展农产品加工业</u>，加快一二三产业融合发展，让贫困户更多分享农业全产业链和价值链增值收益。<u>加大对贫困地区农产品品牌推介营销支持力度</u>。依托贫困地区特有的自然人文资源，<u>深入实施乡村旅游扶贫工程</u>。科学合理有序开发贫困地区水电、煤炭、油气等资源，<u>调整完善资源开发收益分配政策</u>。<u>探索水电利益共享机制</u>，将从发电中提取的资金优先用于水库移民和库区后续发展。<u>引导中央企业、民营企业分别设立贫困地区产业投资基金</u>，采取市场化运作方式，主要用于吸引企业到贫困地区从事资源开发、产业园区建设、新型城镇化发展等。</p>

    <p><strong>（六）引导劳务输出脱贫。</strong>加大劳务输出培训投入，统筹使用各类培训资源，以就业为导向，提高培训的针对性和有效性。加大职业技能提升计划和贫困户教育培训工程实施力度，引导企业扶贫与职业教育相结合，鼓励职业院校和技工学校招收贫困家庭子女，<u>确保贫困家庭劳动力至少掌握一门致富技能，实现靠技能脱贫</u>。进一步加大<u>就业专项资金向贫困地区转移支付力度</u>。支持贫困地区建设县乡基层劳动就业和社会保障服务平台，引导和支持用人企业在贫困地区建立劳务培训基地，开展好订单定向培训，建立和完善输出地与输入地劳务对接机制。<u>鼓励地方对跨省务工的农村贫困人口给予交通补助</u>。大力支持家政服务、物流配送、养老服务等产业发展，拓展贫困地区劳动力外出就业空间。<u>加大对贫困地区农民工返乡创业政策扶持力度</u>。对在城镇工作生活一年以上的农村贫困人口，输入地政府要承担相应的帮扶责任，并优先提供基本公共服务，促进有能力在城镇稳定就业和生活的农村贫困人口有序实现市民化。</p>

    <p><strong>（七）实施易地搬迁脱贫。</strong>对居住在生存条件恶劣、生态环境脆弱、自然灾害频发等地区的农村贫困人口，加快实施易地扶贫搬迁工程。坚持<u>群众自愿、积极稳妥</u>的原则，因地制宜选择搬迁安置方式，合理确定住房建设标准，完善搬迁后续扶持政策，<u>确保搬迁对象有业可就、稳定脱贫，做到搬得出、稳得住、能致富</u>。要紧密结合推进新型城镇化，编制实施易地扶贫搬迁规划，支持有条件的地方依托小城镇、工业园区安置搬迁群众，帮助其尽快实现转移就业，享有与当地群众同等的基本公共服务。加大中央预算内投资和地方各级政府投入力度，创新投融资机制，拓宽资金来源渠道，提高补助标准。积极整<u>合交通建设、农田水利、土地整治、地质灾害防治、林业生态等支农资金和社会资金</u>，支持安置区配套公共设施建设和迁出区生态修复。<u>利用城乡建设用地增减挂钩政策支持易地扶贫搬迁</u>。为<u>符合条件的搬迁户提供建房、生产、创业贴息贷款支持</u>。支持搬迁安置点发展物业经济，增加搬迁户财产性收入。<u>探索利用农民进城落户后自愿有偿退出的农村空置房屋和土地安置易地搬迁农户</u>。</p>

    <p><strong>（八）结合生态保护脱贫。</strong>国家实施的退耕还林还草、天然林保护、防护林建设、石漠化治理、防沙治沙、湿地保护与恢复、坡耕地综合整治、退牧还草、水生态治理等重大生态工程，<u>在项目和资金安排上进一步向贫困地区倾斜</u>，提高贫困人口参与度和受益水平。加大贫困地区生态保护修复力度，<u>增加重点生态功能区转移支付</u>。结合建立国家公园体制，创新生态资金使用方式，利用生态补偿和生态保护工程资金使当地有劳动能力的部分贫困人口转为护林员等生态保护人员。<u>合理调整贫困地区基本农田保有指标</u>，加大贫困地区新一轮退耕还林还草力度。开展贫困地区生态综合补偿试点，健全公益林补偿标准动态调整机制，完善草原生态保护补助奖励政策，推动地区间建立横向生态补偿制度。</p>

    <p><strong>（九）着力加强教育脱贫。</strong>加快实施教育扶贫工程，让贫困家庭子女都能接受公平有质量的教育，<u>阻断贫困代际传递</u>。国家教育经费向贫困地区、基础教育倾斜。健全学前教育资助制度，帮助农村贫困家庭幼儿接受学前教育。稳步推进贫困地区农村义务教育阶段学生营养改善计划。加大对乡村教师队伍建设的支持力度，特岗计划、国培计划向贫困地区基层倾斜，为贫困地区乡村学校定向培养留得下、稳得住的一专多能教师，制定符合基层实际的教师招聘引进办法，<u>建立省级统筹乡村教师补充机制</u>，推动城乡教师合理流动和对口支援。全面落实连片特困地区乡村教师生活补助政策，建立乡村教师荣誉制度。合理布局贫困地区农村中小学校，改善基本办学条件，加快标准化建设，加强寄宿制学校建设，提高义务教育巩固率。普及高中阶段教育，率先从建档立卡的家庭经济困难学生实施普通高中免除学杂费、中等职业教育免除学杂费，让未升入普通高中的初中毕业生都能接受中等职业教育。加强有专业特色并适应市场需求的中等职业学校建设，提高中等职业教育国家助学金资助标准。<u>努力办好贫困地区特殊教育和远程教育</u>。建立保障农村和贫困地区学生上重点高校的长效机制，<u>加大对贫困家庭大学生的救助力度</u>。<u>对贫困家庭离校未就业的高校毕业生提供就业支持</u>。实施教育扶贫结对帮扶行动计划。</p>

    <p><strong>（十）开展医疗保险和医疗救助脱贫。</strong>实施健康扶贫工程，保障贫困人口享有基本医疗卫生服务，努力<u>防止因病致贫、因病返贫</u>。对贫困人口参加新型农村合作医疗个人缴费部分<u>由财政给予补贴</u>。新型农村合作医疗和大病保险制度对贫困人口实行政策倾斜，门诊统筹率先覆盖所有贫困地区，降低贫困人口大病费用实际支出，对新型农村合作医疗和大病保险支付后自负费用仍有困难的，加大医疗救助、临时救助、慈善救助等帮扶力度，<u>将贫困人口全部纳入重特大疾病救助范围</u>，使贫困人口大病医治得到有效保障。加大农村贫困残疾人康复服务和医疗救助力度，扩大纳入基本医疗保险范围的残疾人医疗康复项目。<u>建立贫困人口健康卡</u>。对<u>贫困人口大病实行分类救治和先诊疗后付费的结算机制</u>。建立全国三级医院（含军队和武警部队医院）与连片特困地区县和国家扶贫开发工作重点县县级医院稳定持续的一对一帮扶关系。完成贫困地区县乡村三级医疗卫生服务网络标准化建设，积极促进远程医疗诊治和保健咨询服务向贫困地区延伸。为贫困地区县乡医疗卫生机构订单定向免费培养医学类本专科学生，支持贫困地区实施全科医生和专科医生特设岗位计划，制定符合基层实际的人才招聘引进办法。支持和引导符合条件的贫困地区乡村医生按规定参加城镇职工基本养老保险。采取针对性措施，加强贫困地区传染病、地方病、慢性病等防治工作。全面实施贫困地区儿童营养改善、新生儿疾病免费筛查、妇女&ldquo;两癌&rdquo;免费筛查、孕前优生健康免费检查等重大公共卫生项目。加强贫困地区计划生育服务管理工作。</p>

    <p><strong>（十一）实行农村最低生活保障制度兜底脱贫。</strong>完善农村最低生活保障制度，对无法依靠产业扶持和就业帮助脱贫的家庭<u>实行政策性保障兜底</u>。加大农村低保省级统筹力度，<u>低保标准较低的地区要逐步达到国家扶贫标准</u>。尽快制定农村最低生活保障制度与扶贫开发政策有效衔接的实施方案。进一步加强农村低保申请家庭经济状况核查工作，将<u>所有符合条件的贫困家庭纳入低保范围</u>，做到应保尽保。加大临时救助制度在贫困地区落实力度。提高农村特困人员供养水平，改善供养条件。抓紧建立农村低保和扶贫开发的数据互通、资源共享信息平台，实现动态监测管理、工作机制有效衔接。加快完善城乡居民基本养老保险制度，适时提高基础养老金标准，引导农村贫困人口积极参保续保，逐步提高保障水平。有条件、有需求地区可以实施&ldquo;以粮济贫&rdquo;。</p>

    <p><strong>（十二）探索资产收益扶贫。</strong>在不改变用途的情况下，财政专项扶贫资金和其他涉农资金投入设施农业、养殖、光伏、水电、乡村旅游等项目形成的资产，<u>具备条件的可折股量化给贫困村和贫困户</u>，尤其是丧失劳动能力的贫困户。资产可由村集体、合作社或其他经营主体统一经营。要强化监督管理，明确资产运营方对财政资金形成资产的保值增值责任，建立健全收益分配机制，<u>确保资产收益及时回馈持股贫困户</u>。支持农民合作社和其他经营主体通过土地托管、牲畜托养和吸收农民土地经营权入股等方式，带动贫困户增收。贫困地区水电、矿产等资源开发，<u>赋予土地被占用的村集体股权</u>，让贫困人口分享资源开发收益。</p>

    <p><strong>（十三）健全留守儿童、留守妇女、留守老人和残疾人关爱服务体系。</strong>对农村&ldquo;三留守&rdquo;人员和残疾人进行全面摸底排查，建立详实完备、动态更新的信息管理系统。加强儿童福利院、救助保护机构、特困人员供养机构、残疾人康复托养机构、社区儿童之家等服务设施和队伍建设，不断提高管理服务水平。建立家庭、学校、基层组织、政府和社会力量相衔接的留守儿童关爱服务网络。加强对未成年人的监护。健全孤儿、事实无人抚养儿童、低收入家庭重病重残等困境儿童的福利保障体系。健全发现报告、应急处置、帮扶干预机制，帮助特殊贫困家庭解决实际困难。加大贫困残疾人康复工程、特殊教育、技能培训、托养服务实施力度。针对残疾人的特殊困难，全面建立困难残疾人生活补贴和重度残疾人护理补贴制度。对低保家庭中的老年人、未成年人、重度残疾人等重点救助对象，提高救助水平，确保基本生活。引导和鼓励社会力量参与特殊群体关爱服务工作。</p>

    <p>四、加强贫困地区基础设施建设，加快破除发展瓶颈制约</p>

    <p><strong>（十四）加快交通、水利、电力建设。</strong>推动国家铁路网、国家高速公路网连接贫困地区的重大交通项目建设，提高国道省道技术标准，<u>构建贫困地区外通内联的交通运输通道</u>。大幅度增加中央投资投入中西部地区和贫困地区的铁路、公路建设，继续实施车购税对农村公路建设的专项转移政策，提高贫困地区农村公路建设补助标准，加快完成具备条件的乡镇和建制村通硬化路的建设任务，加强农村公路安全防护和危桥改造，推动一定人口规模的自然村通公路。加强贫困地区重大水利工程、病险水库水闸除险加固、灌区续建配套与节水改造等水利项目建设。实施农村饮水安全巩固提升工程，全面解决贫困人口饮水安全问题。<u>小型农田水利、&ldquo;五小水利&rdquo;工程等建设向贫困村倾斜</u>。对贫困地区农村公益性基础设施管理养护给予支持。加大对贫困地区抗旱水源建设、中小河流治理、水土流失综合治理力度。加强山洪和地质灾害防治体系建设。大力扶持贫困地区农村水电开发。加强贫困地区农村气象为农服务体系和灾害防御体系建设。加快推进贫困地区农网改造升级，全面提升农网供电能力和供电质量，制定贫困村通动力电规划，提升贫困地区电力普遍服务水平。<u>增加贫困地区年度发电指标</u>。提高贫困地区水电工程留存电量比例。加快推进光伏扶贫工程，支持光伏发电设施接入电网运行，发展光伏农业。</p>

    <p><strong>（十五）加大&ldquo;互联网</strong><strong>+</strong><strong>&rdquo;扶贫力度。</strong>完善电信普遍服务补偿机制，加快推进宽带网络覆盖贫困村。实施电商扶贫工程。加快贫困地区物流配送体系建设，支持邮政、供销合作等系统在贫困乡村建立服务网点。支持电商企业拓展农村业务，<u>加强贫困地区农产品网上销售平台建设</u>。加强贫困地区农村电商人才培训。对贫困家庭开设网店给予网络资费补助、小额信贷等支持。开展互联网为农便民服务，提升贫困地区农村互联网金融服务水平，扩大信息进村入户覆盖面。</p>

    <p><strong>（十六）加快农村危房改造和人居环境整治。</strong>加快推进贫困地区农村危房改造，统筹开展农房抗震改造，<u>把建档立卡贫困户放在优先位置</u>，提高补助标准，探索采用贷款贴息、建设集体公租房等多种方式，切实保障贫困户基本住房安全。加大贫困村生活垃圾处理、污水治理、改厕和村庄绿化美化力度。加大贫困地区传统村落保护力度。继续推进贫困地区农村环境连片整治。加大贫困地区以工代赈投入力度，支持农村山水田林路建设和小流域综合治理。财政支持的微小型建设项目，涉及贫困村的，允许按照一事一议方式直接委托村级组织自建自管。以整村推进为平台，加快改善贫困村生产生活条件，扎实推进美丽宜居乡村建设。</p>

    <p><strong>（十七）重点支持革命老区、民族地区、边疆地区、连片特困地区脱贫攻坚。</strong>出台加大脱贫攻坚力度支持革命老区开发建设指导意见，加快实施重点贫困革命老区振兴发展规划，扩大革命老区财政转移支付规模。加快推进民族地区重大基础设施项目和民生工程建设，实施少数民族特困地区和特困群体综合扶贫工程，出台人口较少民族整体脱贫的特殊政策措施。改善边疆民族地区义务教育阶段基本办学条件，建立健全双语教学体系，加大教育对口支援力度，积极发展符合民族地区实际的职业教育，加强民族地区师资培训。加强少数民族特色村镇保护与发展。大力推进兴边富民行动，加大边境地区转移支付力度，完善边民补贴机制，充分考虑边境地区特殊需要，集中改善边民生产生活条件，扶持发展边境贸易和特色经济，使边民能够安心生产生活、安心守边固边。完善片区联系协调机制，加快实施集中连片特殊困难地区区域发展与脱贫攻坚规划。加大中央投入力度，采取特殊扶持政策，推进西藏、四省藏区和新疆南疆四地州脱贫攻坚。</p>

    <p>五、强化政策保障，健全脱贫攻坚支撑体系</p>

    <p><strong>（十八）加大财政扶贫投入力度。</strong>发挥政府投入在扶贫开发中的主体和主导作用，积极开辟扶贫开发新的资金渠道，<u>确保政府扶贫投入力度与脱贫攻坚任务相适应</u>。中央财政继续加大对贫困地区的转移支付力度，中央财政专项扶贫资金规模实现较大幅度增长，一般性转移支付资金、各类涉及民生的专项转移支付资金和中央预算内投资<u>进一步向贫困地区和贫困人口倾斜</u>。加大中央集中彩票公益金对扶贫的支持力度。农业综合开发、农村综合改革转移支付等涉农资金<u>要明确一定比例用于贫困村</u>。各部门安排的各项惠民政策、项目和工程，<u>要最大限度地向贫困地区、贫困村、贫困人口倾斜</u>。各省（自治区、直辖市）要根据本地脱贫攻坚需要，积极调整省级财政支出结构，切实加大扶贫资金投入。从2016年起通过扩大中央和地方财政支出规模，增加对贫困地区水电路气网等基础设施建设和提高基本公共服务水平的投入。建立健全脱贫攻坚多规划衔接、多部门协调长效机制，<u>整合目标相近、方向类同的涉农资金</u>。按照权责一致原则，支持连片特困地区县和国家扶贫开发工作重点县围绕本县突出问题，以扶贫规划为引领，以重点扶贫项目为平台，把专项扶贫资金、相关涉农资金和社会帮扶资金<u>捆绑集中使用</u>。严格落实国家在贫困地区安排的公益性建设项目取<u>消县级和西部连片特困地区地市级配套资金的政策</u>，并加大中央和省级财政投资补助比重。在扶贫开发中推广政府与社会资本合作、政府购买服务等模式。加强财政监督检查和审计、稽查等工作，建立扶贫资金违规使用责任追究制度。纪检监察机关对扶贫领域虚报冒领、截留私分、贪污挪用、挥霍浪费等违法违规问题，坚决从严惩处。推进扶贫开发领域反腐倡廉建设，集中整治和加强预防扶贫领域职务犯罪工作。贫困地区要建立扶贫公告公示制度，强化社会监督，保障资金在阳光下运行。</p>

    <p><strong>（十九）加大金融扶贫力度。</strong>鼓励和引导商业性、政策性、开发性、合作性等各类金融机构加大对扶贫开发的金融支持。运用多种货币政策工具，向金融机构<u>提供长期、低成本的资金</u>，用于支持扶贫开发。<u>设立扶贫再贷款</u>，实行比支农再贷款更优惠的利率，重点支持贫困地区发展特色产业和贫困人口就业创业。运用适当的政策安排，动用财政贴息资金及部分金融机构的富余资金，对接政策性、开发性金融机构的资金需求，拓宽扶贫资金来源渠道。由国家开发银行和中国农业发展银行<u>发行政策性金融债</u>，按照微利或保本的原则发放长期贷款，中央财政给予90%的贷款贴息，<u>专项用于易地扶贫搬迁</u>。国家开发银行、中国农业发展银行分别设立&ldquo;扶贫金融事业部&rdquo;，依法享受税收优惠。中国农业银行、邮政储蓄银行、农村信用社等金融机构要延伸服务网络，创新金融产品，增<u>加贫困地区信贷投放</u>。对有稳定还款来源的扶贫项目，允许采用过桥贷款方式，撬动信贷资金投入。按照省（自治区、直辖市）负总责的要求，建立和完善省级扶贫开发投融资主体。支持农村信用社、村镇银行等金融机构为贫困户提供免抵押、免担保扶贫小额信贷，<u>由财政按基础利率贴息</u>。加大创业担保贷款、助学贷款、妇女小额贷款、康复扶贫贷款实施力度。优先支持在贫困地区设立村镇银行、小额贷款公司等机构。支持贫困地区培育发展农民资金互助组织，开展农民合作社信用合作试点。支持贫困地区<u>设立扶贫贷款风险补偿基金</u>。支持贫困地区设立政府出资的融资担保机构，重点开展扶贫担保业务。积极发展扶贫小额贷款保证保险，对贫困户保证保险保费予以补助。扩大农业保险覆盖面，通过中央财政以奖代补等支持贫困地区特色农产品保险发展。加强贫困地区金融服务基础设施建设，优化金融生态环境。支持贫困地区开展特色农产品价格保险，有条件的地方可给予一定保费补贴。有效拓展贫困地区抵押物担保范围。</p>

    <p><strong>（二十）完善扶贫开发用地政策。</strong>支持贫困地区根据第二次全国土地调查及最新年度变更调查成果，调整完善土地利用总体规划。新增建设用地计划指标优先保障扶贫开发用地需要，<u>专项安排国家扶贫开发工作重点县年度新增建设用地计划指标</u>。中央和省级在安排土地整治工程和项目、分配下达高标准基本农田建设计划和补助资金时，要<u>向贫困地区倾斜</u>。在连片特困地区和国家扶贫开发工作重点县开展易地扶贫搬迁，<u>允许将城乡建设用地增减挂钩指标在省域范围内使用</u>。在有条件的贫困地区，优先安排国土资源管理制度改革试点，支持开展历史遗留工矿废弃地复垦利用、城镇低效用地再开发和低丘缓坡荒滩等未利用地开发利用试点。</p>

    <p><strong>（二十一）发挥科技、人才支撑作用。</strong>加大科技扶贫力度，解决贫困地区特色产业发展和生态建设中的关键技术问题。加大技术创新引导专项（基金）对科技扶贫的支持，加快先进适用技术成果在贫困地区的转化。深入推行科技特派员制度，<u>支持科技特派员开展创业式扶贫服务</u>。强化贫困地区基层农技推广体系建设，<u>加强新型职业农民培训</u>。加大政策激励力度，鼓励各类人才扎根贫困地区基层建功立业，<u>对表现优秀的人员在职称评聘等方面给予倾斜</u>。大力实施边远贫困地区、边疆民族地区和革命老区人才支持计划，贫困地区本土人才培养计划。积极推进贫困村创业致富带头人培训工程。</p>

    <p>六、广泛动员全社会力量，合力推进脱贫攻坚</p>

    <p><strong>（二十二）健全东西部扶贫协作机制。</strong>加大东西部扶贫协作力度，建立精准对接机制，使帮扶资金主要用于贫困村、贫困户。东部地区要根据财力增长情况，逐步增加对口帮扶财政投入，并列入年度预算。强化以企业合作为载体的扶贫协作，鼓励东西部按照当地主体功能定位共建产业园区，推动东部人才、资金、技术向贫困地区流动。启动实施经济强县（市）与国家扶贫开发工作重点县&ldquo;携手奔小康&rdquo;行动，东部各省（直辖市）在努力做好本区域内扶贫开发工作的同时，更多发挥县（市）作用，与扶贫协作省份的国家扶贫开发工作重点县开展结对帮扶。建立东西部扶贫协作考核评价机制。</p>

    <p><strong>（二十三）健全定点扶贫机制。</strong>进一步加强和改进定点扶贫工作，建立考核评价机制，确保各单位落实扶贫责任。深入推进中央企业定点帮扶贫困革命老区县&ldquo;百县万村&rdquo;活动。完善定点扶贫牵头联系机制，各牵头部门要按照分工督促指导各单位做好定点扶贫工作。</p>

    <p><strong>（二十四）健全社会力量参与机制。</strong>鼓励支持民营企业、社会组织、个人参与扶贫开发，实现<u>社会帮扶资源和精准扶贫有效对接</u>。引导社会扶贫重心下移，自愿包村包户，做到贫困户都有党员干部或爱心人士结对帮扶。吸纳农村贫困人口就业的企业，按规定享受税收优惠、职业培训补贴等就业支持政策。<u>落实企业和个人公益扶贫捐赠所得税税前扣除政策</u>。充分发挥各民主党派、无党派人士在人才和智力扶贫上的优势和作用。工商联系统组织民营企业开展&ldquo;万企帮万村&rdquo;精准扶贫行动。通过政府购买服务等方式，鼓励各类社会组织开展到村到户精准扶贫。完善扶贫龙头企业认定制度，增强企业辐射带动贫困户增收的能力。鼓励有条件的企业设立扶贫公益基金和开展扶贫公益信托。发挥好&ldquo;10&middot;17&rdquo;全国扶贫日社会动员作用。实施扶贫志愿者行动计划和社会工作专业人才服务贫困地区计划。着力打造扶贫公益品牌，全面及时公开扶贫捐赠信息，提高社会扶贫公信力和美誉度。构建社会扶贫信息服务网络，探索发展公益众筹扶贫。</p>

    <p>七、大力营造良好氛围，为脱贫攻坚提供强大精神动力</p>

    <p><strong>（二十五）创新中国特色扶贫开发理论。</strong>深刻领会习近平总书记关于新时期扶贫开发的重要战略思想，系统总结我们党和政府领导亿万人民摆脱贫困的历史经验，提炼升华精准扶贫的实践成果，不断丰富完善中国特色扶贫开发理论，为脱贫攻坚注入强大思想动力。</p>

    <p><strong>（二十六）加强贫困地区乡风文明建设。</strong>培育和践行社会主义核心价值观，大力弘扬中华民族自强不息、扶贫济困传统美德，振奋贫困地区广大干部群众精神，坚定改变贫困落后面貌的信心和决心，<u>凝聚全党全社会扶贫开发强大合力</u>。倡导现代文明理念和生活方式，改变落后风俗习惯，善于发挥乡规民约在扶贫济困中的积极作用，激发贫困群众奋发脱贫的热情。推动文化投入向贫困地区倾斜，集中实施一批文化惠民扶贫项目，普遍建立村级文化中心。深化贫困地区文明村镇和文明家庭创建。推动贫困地区县级公共文化体育设施达到国家标准。支持贫困地区挖掘保护和开发利用红色、民族、民间文化资源。鼓励文化单位、文艺工作者和其他社会力量为贫困地区提供文化产品和服务。</p>

    <p><strong>（二十七）扎实做好脱贫攻坚宣传工作。</strong>坚持正确舆论导向，全面宣传我国扶贫事业取得的重大成就，准确解读党和政府扶贫开发的决策部署、政策举措，生动报道各地区各部门精准扶贫、精准脱贫丰富实践和先进典型。<u>建立国家扶贫荣誉制度</u>，表彰对扶贫开发作出杰出贡献的组织和个人。加强对外宣传，讲好减贫的中国故事，传播好减贫的中国声音，阐述好减贫的中国理念。</p>

    <p><strong>（二十八）加强国际减贫领域交流合作。</strong>通过对外援助、项目合作、技术扩散、智库交流等多种形式，加强与发展中国家和国际机构在减贫领域的交流合作。积极借鉴国际先进减贫理念与经验。履行减贫国际责任，积极落实联合国2030年可持续发展议程，对全球减贫事业作出更大贡献。</p>

    <p>八、切实加强党的领导，为脱贫攻坚提供坚强政治保障</p>

    <p><strong>（二十九）强化脱贫攻坚领导责任制。</strong>实行<u>中央统筹、省（自治区、直辖市）负总责、市（地）县抓落实</u>的工作机制，坚持片区为重点、精准到村到户。党中央、国务院主要负责统筹制定扶贫开发大政方针，出台重大政策举措，规划重大工程项目。省（自治区、直辖市）党委和政府对扶贫开发工作负总责，抓好目标确定、项目下达、资金投放、组织动员、监督考核等工作。<u>市（地）党委和政府要做好上下衔接、域内协调、督促检查工作，把精力集中在贫困县如期摘帽上</u>。<u>县级党委和政府承担主体责任</u>，书记和县长是第一责任人，做好进度安排、项目落地、资金使用、人力调配、推进实施等工作。要层层签订脱贫攻坚责任书，扶贫开发任务重的省（自治区、直辖市）党政主要领导要向中央签署脱贫责任书，每年要向中央作扶贫脱贫进展情况的报告。省（自治区、直辖市）党委和政府要向市（地）、县（市）、乡镇提出要求，层层落实责任制。中央和国家机关各部门要按照部门职责落实扶贫开发责任，实现部门专项规划与脱贫攻坚规划有效衔接，充分运用行业资源做好扶贫开发工作。军队和武警部队要发挥优势，积极参与地方扶贫开发。改进县级干部选拔任用机制，统筹省（自治区、直辖市）内优秀干部，选好配强扶贫任务重的县党政主要领导，把扶贫开发工作实绩作为选拔使用干部的重要依据。<u>脱贫攻坚期内贫困县县级领导班子要保持稳定，对表现优秀、符合条件的可以就地提级</u>。加大选派优秀年轻干部特别是后备干部到贫困地区工作的力度，有计划地安排省部级后备干部到贫困县挂职任职，各省（自治区、直辖市）党委和政府也要选派厅局级后备干部到贫困县挂职任职。各级领导干部要自觉践行党的群众路线，切实转变作风，把严的要求、实的作风贯穿于脱贫攻坚始终。</p>

    <p><strong>（三十）发挥基层党组织战斗堡垒作用。</strong><u>加强贫困乡镇领导班子建设</u>，有针对性地选配政治素质高、工作能力强、熟悉&ldquo;三农&rdquo;工作的干部担任贫困乡镇党政主要领导。<u>抓好以村党组织为领导核心的村级组织配套建设</u>，集中整顿软弱涣散村党组织，提高贫困村党组织的创造力、凝聚力、战斗力，发挥好工会、共青团、妇联等群团组织的作用。<u>选好配强村级领导班子</u>，突出抓好村党组织带头人队伍建设，充分发挥党员先锋模范作用。<u>完善村级组织运转经费保障机制</u>，将村干部报酬、村办公经费和其他必要支出作为保障重点。注重选派思想好、作风正、能力强的优秀年轻干部到贫困地区驻村，选聘高校毕业生到贫困村工作。根据贫困村的实际需求，精准选配第一书记，精准选派驻村工作队，提高县以上机关派出干部比例。<u>加大驻村干部考核力度，不稳定脱贫不撤队伍</u>。对在基层一线干出成绩、群众欢迎的驻村干部，要重点培养使用。加快推进贫困村村务监督委员会建设，继续落实好&ldquo;四议两公开&rdquo;、村务联席会等制度，健全党组织领导的村民自治机制。在有实际需要的地区，探索在村民小组或自然村开展村民自治，通过议事协商，组织群众自觉广泛参与扶贫开发。</p>

    <p><strong>（三十一）严格扶贫考核督查问责。</strong>抓紧出台中央对省（自治区、直辖市）党委和政府扶贫开发工作成效考核办法。<u>建立年度扶贫开发工作逐级督查制度</u>，选择重点部门、重点地区进行联合督查，对落实不力的部门和地区，国务院扶贫开发领导小组要向党中央、国务院报告并提出责任追究建议，<u>对未完成年度减贫任务的省份要对党政主要领导进行约谈</u>。各省（自治区、直辖市）党委和政府要加快出台对贫困县扶贫绩效考核办法，<u>大幅度提高减贫指标在贫困县经济社会发展实绩考核指标中的权重</u>，<u>建立扶贫工作责任清单</u>。加快<u>落实对限制开发区域和生态脆弱的贫困县取消地区生产总值考核的要求</u>。落实贫困县约束机制，严禁铺张浪费，厉行勤俭节约，严格控制&ldquo;三公&rdquo;经费，坚决刹住穷县&ldquo;富衙&rdquo;、&ldquo;戴帽&rdquo;炫富之风，杜绝不切实际的形象工程。建立重大涉贫事件的处置、反馈机制，在处置典型事件中发现问题，不断提高扶贫工作水平。加强农村贫困统计监测体系建设，提高监测能力和数据质量，实现数据共享。</p>

    <p><strong>（三十二）加强扶贫开发队伍建设。</strong>稳定和强化各级扶贫开发领导小组和工作机构。扶贫开发任务重的省（自治区、直辖市）、<u>市（地）、县（市）扶贫开发领导小组组长由党政主要负责同志担任</u>，强化各级扶贫开发领导小组决策部署、统筹协调、督促落实、检查考核的职能。加强与精准扶贫工作要求相适应的扶贫开发队伍和机构建设，完善各级扶贫开发机构的设置和职能，充实配强各级扶贫开发工作力度。扶贫任务重的乡镇要有专门干部负责扶贫开发工作。加强贫困地区县级领导干部和扶贫干部思想作风建设，加大培训力度，全面提升扶贫干部队伍能力水平。</p>

    <p><strong>（三十三）推进扶贫开发法治建设。</strong>各级党委和政府要切实履行责任，善于运用法治思维和法治方式推进扶贫开发工作，在规划编制、项目安排、资金使用、监督管理等方面，<u>提高规范化、制度化、法治化水平</u>。强化贫困地区社会治安防控体系建设和基层执法队伍建设。健全贫困地区公共法律服务制度，切实保障贫困人口合法权益。完善扶贫开发法律法规，抓紧制定扶贫开发条例。</p>

    <p>让我们更加紧密地团结在以习近平同志为总书记的党中央周围，凝心聚力，精准发力，苦干实干，坚决打赢脱贫攻坚战，为全面建成小康社会、实现中华民族伟大复兴的中国梦而努力奋斗。</p>

    <p style="text-align:right">&nbsp;</p>

    '''
    creator: '中共中央国务院'
    created_at: '2016-01-01 23:33'
    updated_at: '2016-01-02 07:11'
  ]

  $scope.about = "
  <p>
  &nbsp;&nbsp;&nbsp;&nbsp;中国西部研究与发展促进会健康中国推进工作委员会，是中国西部研究与发展促进会的直属机构。<br>
  &nbsp;&nbsp;&nbsp;&nbsp;委员会以党的科学发展观为指导，促进我国西部地区健康中国战略推进工作有序发展为目标，认真做好改善西部地区医疗卫生条件、促进人才与信息交流、为有需要的地区提供医疗卫生帮扶工作。为政府主管部门和医疗卫生领域的科研机构、生产企业、设计、检测机构、大专院校、学术团体提供服务；协调政府机构或组织与企业之间、医疗卫生科研机构与企业之间、企业与企业之间、医疗卫生产品与用户之间的关系，发挥桥梁与纽带作用，促进我国医疗公共卫生事业的健康发展。<br>
  &nbsp;&nbsp;&nbsp;&nbsp;委员会办公地点设在北京。<br>
  </p>
  "

  $scope.notify = "
  <strong>“健康中国2020”</strong>：改善城乡居民健康状况，提高国民健康生活质量，减少不同地区健康状况差异，主要健康指标基本达到中等发达国家水平。<br>&nbsp;&nbsp;&nbsp;&nbsp;到2015年，基本医疗卫生制度初步建立，使全体国民人人拥有基本医疗保障、人人享有基本公共卫生服务，医疗卫生服务可及性明显增强，地区间人群健康状况和资源配置差异明显缩小，国民健康水平居于发展中国家前列。<br>&nbsp;&nbsp;&nbsp;&nbsp;到2020年，完善覆盖城乡居民的基本医疗卫生制度，实现人人享有基本医疗卫生服务，医疗保障水平不断提高，卫生服务利用明显改善，地区间人群健康差异进一步缩小，国民健康水平达到中等发达国家水平。
  "

  $scope.contact = '''<p>健康中国推进工作委员会</p>

  <p>地址：北京市西城区永安路106号</p>

  <p>邮编：100050</p>

  <p>电话号码：010-83167988</p>

  <p>传真号码：010-83151568</p>

  <p>电子邮箱：<a href="mailto:44228557@qq.com">44228557@qq.com</a></p>

  <p style="text-align:right">&nbsp;</p>
  '''

  $scope.policy_list = [
    title: '工作条例'
    content: '''
    <h1 style="text-align: center;">&nbsp;&nbsp;&nbsp; 中国西部研究与发展促进会健康中国推进工作委员会&nbsp;&nbsp;</h1>

    <h2 style="text-align: center;">工作条例</h2>

    <p>&nbsp;</p>

    <p style="text-align: center;"><strong>第一章</strong><strong>&nbsp; 总则</strong></p>

    <p><br />
    <strong>第一条&nbsp; 中国西部研究与发展促进会健康中国推进工作委员会（以下简称：委员会），是中国西部研究与发展促进会的直属机构；</strong></p>

    <p><br />
    <strong>第二条&nbsp; 委员会的宗旨：以党的科学发展观为指导，促进我国西部地区健康中国战略推进工作有序发展为目标，认真做好改善西部地区医疗卫生条件、促进人才与信息交流、为有需要的地区提供医疗卫生帮扶工作。</strong></p>

    <p>&nbsp;</p>

    <p><strong>第三条 为政府主管部门和医疗卫生领域的科研机构、生产企业、设计、检测机构、大专院校、学术团体提供服务；</strong></p>

    <p>&nbsp;</p>

    <p><strong>第四条&nbsp; 协调政府机构或组织与企业之间、医疗卫生科研机构与企业之间、企业与企业之间、医疗卫生产品与用户之间的关系，发挥桥梁与纽带作用，促进我国医疗公共卫生事业的健康发展。</strong></p>

    <p>&nbsp;</p>

    <p><strong>第五条</strong><strong>&nbsp; 委员会办公地点设在北京。</strong></p>

    <p style="text-align: center;"><strong>第二章&nbsp; 工作任务</strong></p>

    <p><br />
    <strong>第六条&nbsp; 认真贯彻党的十八届五中全会精神及国家经济转型的方针和政策，宣传国家关于医疗卫生的政策、法规；</strong></p>

    <p><br />
    <strong>（1）根据医疗卫生领域经济发展趋势和科技科研成果应用的市场状态，参与医疗卫生行业标准的考察调研并编写调研报告、制定工作，为政府在医疗卫生领域的决策提供科学依据。</strong></p>

    <p><strong>（</strong><strong>2）推广优秀的医疗卫生科研成果和先进的技术、促进医疗卫生科研成果和先进技术的应用，为医疗卫生经济发展服务。</strong></p>

    <p><strong>三</strong><strong>&nbsp; 编辑出版医疗卫生科技创新和新产品的应用等相关资料和书刊，普及医疗卫生科学知识和宣传国内外医疗卫生事业发展和科技成果应用的时实消息。</strong></p>

    <p><br />
    <strong>四&nbsp; 组织医疗卫生领域的科研机构和生产企业开展科研技术、医疗卫生产品、企业管理等信息交流、展览、咨询、培训等服务活动。建立企业间经济协作关系，提高医疗卫生企业经济效益和社会效益；</strong></p>

    <p><br />
    <strong>五&nbsp; 依法协助相关企业维护自身的合法权益，反映企业呼声，规范企业行为，协调行业关系，促进医疗卫生领域企业的经济发展。</strong></p>

    <p><br />
    <strong>六&nbsp; 收集、整理医疗卫生科研成果应用数据情报，总结相关科研机构、生产企业、使用单位合作应用医疗卫生科研成果的成功经验，进行市场调研，创建医疗卫生经济发展与科研成果数据库，服务于医疗卫生领域。</strong></p>

    <p><br />
    <strong>七&nbsp; 建立和加强同国内外医疗卫生领域的科研机构、学术团体的联系和学术交流，组织医疗卫生领域的专家为科研机构、生产企业服务，参加国内外相关科研技术交流活动。</strong></p>

    <p><strong>八&nbsp; 为医疗卫生产业提供宣传/报道/广告的渠道和平台.</strong></p>

    <p style="text-align: center;"><strong>第三章&nbsp; 委员会服务主要对象</strong></p>

    <p><br />
    <strong>第七条&nbsp; 委员会服务的主要对象是委员会发展的中国西促会会员单位和理事单位；会员和理事单位须是从事医疗卫生领域的科研设计、生产、应用、检测的企事业单位、大专院校、学术团体经委员会初审后，报中国西促会审核批准成为中国西促会会员单位。医疗卫生领域的科研工程技术人员、专家学者，热心医疗卫生领域的志愿者经委员会初审后，报中国西促会审核批准后成为中国西促会会员，均为委员会的优先服务对象。<br />
    第八条&nbsp; 委员会发展的会员权利和义务：<br />
    &nbsp; &nbsp; （委员会发展的）会员依据本条例享有下列权利：<br />
    &nbsp;&nbsp;&nbsp; （1）依据中国西促会章程享有中国西促会会员应当享有的权力以外，优先享有委员会服务的权力。<br />
    &nbsp;&nbsp;&nbsp; （2）对委员会工作的批评建议权和监督权；<br />
    &nbsp;&nbsp;&nbsp; （3）通过委员会和中国西促会向政府有关部门就医疗卫生领域的科研和经济发展提出建议和意见。</strong></p>

    <p><br />
    <strong>第九条&nbsp; 委员会发展的会员应履行下列义务：</strong></p>

    <p><strong>（1）遵守中国西促会的章程执行中国西促会的决议，积极参加健康中国推进工作委员会组织的活动并尽力提供方便和资助；</strong></p>

    <p><strong>（2）维护中国西促会和健康中国推进工作委员会的声誉和合法利益；</strong></p>

    <p><strong>（</strong><strong>3）及时向委员会反映并提供企业管理信息、企业管理调查报告，产品市场分析、科技研究成果、统计数据及其他资料；</strong></p>

    <p><strong>（4）委员会发展的会员按规定交纳会费。<br />
    &nbsp;&nbsp;&nbsp; </strong></p>

    <p><strong>第十条&nbsp; 委员会发展的会员退会应书面通知委员会，由委员会报中国西促会秘书处备案。<br />
    &nbsp;&nbsp;&nbsp; </strong></p>

    <p><strong>第十一条&nbsp; 委员会发展的会员连续2年不缴纳会费，不参加委员会组织活动的视为自动退会，并在中国西促会网站及相关媒体发布公告。<br />
    &nbsp;&nbsp;&nbsp; </strong></p>

    <p><strong>第十二条&nbsp; 委员会发展的会员严重违反中国西促会章程的行为依照中国西促会章程处理。</strong></p>

    <p><strong>&nbsp;&nbsp;&nbsp; </strong></p>

    <p><strong>第十三条&nbsp; 公章的使用管理：公章的刻制及管理由西促会办公室统一管理。</strong></p>

    <p style="text-align: center;"><strong>第四章</strong><strong>&nbsp; 组织机构</strong></p>

    <p><br />
    <strong>第十四条&nbsp; 委员会设:顾问（若干人），主任（一人），副主任（若干人），专家团（若干人）。部门设置须报中国西促会办公室审批同意备案后启动。办公室负责日常工作，并设:健康中国推进工作委员会办公室。</strong></p>

    <ul>
      <li><strong>(1)；委员会顾问：张清华、李丁川、黄平、熊云新、宋友</strong></li>
      <li><strong>(2)；委员会主任：何红莲</strong></li>
      <li><strong>(</strong><strong>3)；委员会副主任：熊云新（兼）、宋友（兼）</strong></li>
      <li><strong>(4)；委员会办公室主任：蒙忠吉</strong></li>
      <li><strong>(5) （1）至（4）所指机构的聘任人员按照相关规定报中国西促会审核备案。</strong></li>
    </ul>

    <p style="text-align: center;"><strong>第五章&nbsp; 经费管理、使用原则</strong></p>

    <p><br />
    <strong>第十五条&nbsp; 经费来源<br />
    &nbsp;&nbsp;&nbsp; 一&nbsp; 会费；<br />
    &nbsp;&nbsp;&nbsp; 二&nbsp; 政府有关机构或组织的资助、企、事单位的捐赠；<br />
    &nbsp;&nbsp;&nbsp; 三&nbsp; 利息；<br />
    &nbsp;&nbsp;&nbsp; 四&nbsp; 其它合法收；</strong></p>

    <p><strong>第十六条</strong><strong>&nbsp; 严格执行民政部规定的社团财务管理规定。委员会不设独立财务，财务由中国西促会统一管理。</strong></p>

    <p style="text-align: center;"><strong>第六章&nbsp; 附则</strong></p>

    <p><br />
    <strong>第十七条&nbsp; 本条例经中国西促会审核通过并备案。</strong></p>

    <p>&nbsp;</p>

    <p><strong>第十八条：本条例是中国西部研究与发展促进会健康中国推进工作委员会工作准则和规程，委员会工作人员应严格遵守。</strong></p>

    <p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p>

    <p><strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 中国西部研究与发展促进会健康中国推进工作委员会</strong></p>

    <p><strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;二〇一五 年 &nbsp;十二 月 七 日</strong></p>

    <p><br />
    &nbsp;</p>

    <p>&nbsp;</p>

    <p><strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</strong></p>

    <p style="text-align:right">&nbsp;</p>'''
    created_at: '2016-01-03 23:33'
    updated_at: '2016-01-04 07:11'
  ,
    "title": '组织架构'
    "content": '''
    <h1 style="text-align: center;"><strong>中国西部研究与发展促进会健康中国推进工作委员会</strong></h1>

    <p><strong>组织架构</strong></p>

    <ul>
      <li>委员会顾问：张清华、李丁川、黄平、熊云新、宋友</li>
      <li>委员会主任：何红莲</li>
      <li>委员会副主任：熊云新（兼）、宋友（兼）</li>
      <li>委员会办公室主任：蒙忠吉</li>
    </ul>

    <p style="text-align:right">&nbsp;</p>

    '''
    created_at: '2016-01-03 23:33'
    updated_at: '2016-01-04 07:11'
  ]
)