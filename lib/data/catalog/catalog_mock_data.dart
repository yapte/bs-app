import 'catalog_models.dart';

const catalogGroups = [
  CatalogGroup(
    id: 'massages',
    title: 'Массажи',
    description:
        'Процедуры для восстановления тонуса, снятия напряжения и глубокого расслабления.',
    procedures: [
      Procedure(
        id: 'sarga-terapiya',
        title: 'САРГА-ТЕРАПИЯ',
        description:
            'Для тех, кому нужно выключить внутреннего критика и максимально расслабиться.',
        duration: '60 минут',
        price: 4000,
        badge: 'Хит',
      ),
      Procedure(
        id: 'kolybel-dushi',
        title: 'Целебная практика «КОЛЫБЕЛЬ ДУШИ»',
        description:
            'Глубокий ритуал восстановления через мягкие техники массажа и заботу о теле.',
        duration: '120 минут',
        price: 7000,
      ),
      Procedure(
        id: 'ritual-dolyubi-sebya',
        title: 'РИТУАЛ «ДОЛЮБИ СЕБЯ»',
        description:
            'Авторский уход для бережного расслабления, принятия и обновления.',
        duration: '90 минут',
        price: 5500,
      ),
      Procedure(
        id: 'miofascialnyy-massazh',
        title: 'Миофасциальный массаж',
        description:
            'Работа с глубокими мышечными слоями для снятия зажимов и улучшения подвижности.',
        duration: '80 минут',
        price: 3800,
      ),
      Procedure(
        id: 'limfodrenazhnyy-massazh',
        title: 'Лимфодренажный массаж',
        description:
            'Помогает уменьшить отечность, улучшить циркуляцию и вернуть легкость.',
        duration: '50 минут',
        price: 2500,
      ),
      Procedure(
        id: 'aromamaslyanyy-massazh',
        title: 'Аромамасляный массаж',
        description:
            'Мягкий массаж с ароматическими маслами для спокойствия и восстановления.',
        duration: '50 минут',
        price: 3000,
      ),
      Procedure(
        id: 'tayskiy-massazh-stop',
        title: 'Тайский массаж стоп',
        description:
            'Тонизирующая процедура для уставших ног и общего ощущения бодрости.',
        duration: '45 минут',
        price: 2500,
      ),
      Procedure(
        id: 'massazh-bolshie-soli',
        title: 'Массаж «Большие Соли»',
        description:
            'Фирменная процедура с акцентом на расслабление спины, шеи и плеч.',
        duration: 'от 40 минут',
        price: 2200,
      ),
    ],
  ),
  CatalogGroup(
    id: 'ayurveda',
    title: 'Аюрведа',
    description:
        'Индийские практики гармонии тела и ума с маслами, травами и мягким прогревом.',
    procedures: [
      Procedure(
        id: 'pinda-svedana',
        title: 'Пинда Сведана',
        description:
            'Массаж тела мешочками с рисом, пропитанными специально приготовленным горячим молоком.',
        duration: '80 минут',
        price: 5200,
      ),
      Procedure(
        id: 'udvartana',
        title: 'Удвартана',
        description:
            'Общий аюрведический массаж тела с травяным порошком и прогревом в хаммаме.',
        duration: '80 минут с мини хаммамом',
        price: 4500,
      ),
      Procedure(
        id: 'shirodhara-head',
        title: 'Широдхара - массаж головы',
        description:
            'Невероятно расслабляющий массаж головы и всего тела со смесью травяных масел.',
        duration: '50 минут',
        price: 6000,
        badge: 'Relax',
      ),
      Procedure(
        id: 'shirodhara-body',
        title: 'Широдхара - массаж всего тела',
        description:
            'Расслабляющий уход для всего тела с теплой смесью травяных масел.',
        duration: 'от 110 минут',
        price: 8500,
      ),
      Procedure(
        id: 'elakizhi',
        title: 'Элакижи',
        description: 'Аюрведический массаж тела пиндами, мешочками с травами.',
        duration: '50 минут',
        price: 4000,
      ),
      Procedure(
        id: 'abhyanga-four-hands',
        title: 'Абхьянга в 4 руки',
        description:
            'Традиционный мягкий масляный массаж всего тела в четыре руки.',
        duration: 'от 80 минут',
        price: 6000,
      ),
      Procedure(
        id: 'ayurvedicheskiy-massazh-golovy',
        title: 'Аюрведический массаж головы',
        description:
            'Запускает естественный механизм роста здоровых волос и снимает напряжение.',
        duration: '25 минут',
        price: 2000,
      ),
      Procedure(
        id: 'kamala-massazh',
        title: '«Камала»-массаж',
        description: 'Аюрведический массаж лица для свежести и тонуса кожи.',
        duration: '40 минут',
        price: 2500,
      ),
    ],
  ),
  CatalogGroup(
    id: 'bath',
    title: 'Банный комплекс',
    description:
        'Русская баня, хаммам и авторские ритуалы с парением, солью, травами и уходами.',
    procedures: [
      Procedure(
        id: 'russkoe-pole',
        title: 'Программа «Русское поле»',
        description:
            'Авторское парение с индивидуальным травяным ковриком и травяной шапочкой.',
        duration: '150 минут',
        price: 11000,
      ),
      Procedure(
        id: 'only-papa',
        title: 'Программа «ONLY ПАПА»',
        description:
            'Программа для настоящих мужчин с насыщенным банным ритуалом.',
        duration: '120 минут',
        price: 9000,
      ),
      Procedure(
        id: 'programma-bolshie-soli',
        title: 'Программа «Большие Соли»',
        description: 'Фирменная программа парения в SPA «Большие Соли».',
        duration: '120 минут',
        price: 7500,
        badge: 'Фирменная',
      ),
      Procedure(
        id: 'charm-detox',
        title: '«CHARM-DETOX»',
        description:
            'Спа-программа для очищения организма в хаммаме на линии Charm d’Orient.',
        duration: '150 минут',
        price: 9000,
      ),
      Procedure(
        id: 'morskaya-prohlada',
        title: '«Морская прохлада»',
        description: 'Спа-программа на эстетической линии Thalasso Bretagne.',
        duration: '120 минут',
        price: 7000,
      ),
      Procedure(
        id: 'turetskiy-mylnyy-massazh',
        title: 'Турецкий мыльный массаж',
        description: 'Проводится в турецкой бане на теплом мраморном столе.',
        duration: '90 минут',
        price: 3500,
      ),
      Procedure(
        id: 'kedrovaya-bochka',
        title: 'Кедровая бочка',
        description:
            'Кедровая фито-мини сауна с благоприятным воздействием на организм.',
        duration: '15 минут',
        price: 1000,
      ),
      Procedure(
        id: 'infrakrasnaya-sauna',
        title: 'Инфракрасная сауна',
        description:
            'Комбинированное воздействие инфракрасного излучения на организм.',
        duration: '40 минут',
        price: 1000,
      ),
    ],
  ),
  CatalogGroup(
    id: 'hydrotherapy',
    title: 'Гидротерапия',
    description:
        'Водные процедуры для расслабления, восстановления мышечного тонуса и снятия стресса.',
    procedures: [
      Procedure(
        id: 'hvoynaya-vanna',
        title: 'Хвойная ванна',
        description:
            'Ароматическая ванна с применением экстракта из натуральной хвои.',
        duration: '20 минут',
        price: 800,
      ),
      Procedure(
        id: 'vakuumnyy-gidromassazh',
        title: 'Вакуумный гидромассаж',
        description:
            'Аппаратная процедура с воздействием воды под давлением и вакуумом.',
        duration: '50 минут',
        price: 3000,
        badge: 'Популярно',
      ),
      Procedure(
        id: 'vanna-melissa',
        title: 'Ванна «Мелисса»',
        description:
            'Эфирное масло мелиссы успокаивает и благотворно влияет на нервную систему.',
        duration: '20 минут',
        price: 800,
      ),
      Procedure(
        id: 'morskaya-vanna',
        title: 'Морская ванна',
        description:
            'Восполняет дефицит минералов, снимает сосудистые спазмы и отечность.',
        duration: '20 минут',
        price: 1000,
      ),
      Procedure(
        id: 'vanna-kleopatra',
        title: 'Ванна красоты «Клеопатра»',
        description:
            'Мягкая процедура, которая хорошо подходит для чувствительной кожи.',
        duration: '20-30 минут',
        price: 2000,
      ),
      Procedure(
        id: 'mineralnaya-vanna',
        title: 'Минеральная ванна',
        description:
            'Ванна с хлоридно-сульфатно-натриевой водой из собственного источника.',
        duration: '15-20 минут',
        price: 700,
      ),
      Procedure(
        id: 'lavanda-vanna',
        title: 'Гармонизирующая ванна «ЛАВАНДА»',
        description:
            'Восстанавливает внутреннее спокойствие и рекомендуется при нервном истощении.',
        duration: '20 минут',
        price: 700,
      ),
      Procedure(
        id: 'gidromassazh',
        title: 'Гидромассаж',
        description:
            'Проводится струей воды под давлением в специальной ванне.',
        duration: '40 минут',
        price: 2200,
      ),
    ],
  ),
];

({CatalogGroup group, Procedure procedure})? findProcedureInCatalog(String id) {
  for (final group in catalogGroups) {
    for (final procedure in group.procedures) {
      if (procedure.id == id) {
        return (group: group, procedure: procedure);
      }
    }
  }

  return null;
}
