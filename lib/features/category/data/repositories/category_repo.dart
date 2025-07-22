import 'package:moneynest/features/category/data/model/category_model.dart';

final List<CategoryModel> categories = [
  CategoryModel(
    id: 1,
    title: 'Ăn uống',
    iconName: 'HugeIcons.strokeRoundedRestaurantMenu', // Example icon name
    description: 'Groceries, restaurants, coffee, snacks, etc.',
    subCategories: [
      CategoryModel(
        id: 101,
        parentId: 1,
        title: 'Mua sắm thực phẩm',
        iconName: 'HugeIcons.strokeRoundedShoppingBasket01',
        description: 'Thực phẩm và đồ dùng gia đình từ siêu thị.',
      ),
      CategoryModel(
        id: 102,
        parentId: 1,
        title: 'Nhà hàng & Quán cafe',
        iconName: 'HugeIcons.strokeRoundedPlate',
        description: 'Ăn ngoài, quán cafe, quán bar.',
      ),
      CategoryModel(
        id: 103,
        parentId: 1,
        title: 'Mang về & Giao hàng',
        iconName: 'HugeIcons.strokeRoundedDeliveryBox01',
        description: 'Đặt đồ ăn giao tận nơi hoặc tự lấy.',
      ),
    ],
  ),
  CategoryModel(
    id: 2,
    title: 'Di chuyển',
    iconName: 'HugeIcons.strokeRoundedBus', // Example icon name
    description: 'Phương tiện công cộng, xăng xe, đi chung xe, chi phí xe cộ.',
    subCategories: [
      CategoryModel(
        id: 201,
        parentId: 2,
        title: 'Giao thông công cộng',
        iconName: 'HugeIcons.strokeRoundedTrain',
        description: 'Xe buýt, tàu, metro, vé tàu điện.',
      ),
      CategoryModel(
        id: 202,
        parentId: 2,
        title: 'Xăng/dầu',
        iconName: 'HugeIcons.strokeRoundedGasStation',
        description: 'Xăng, dầu, sạc xe điện.',
      ),
      CategoryModel(
        id: 203,
        parentId: 2,
        title: 'Taxi & Xe công nghệ',
        iconName: 'HugeIcons.strokeRoundedCar',
        description: 'Uber, Grab, taxi...',
      ),
      CategoryModel(
        id: 204,
        parentId: 2,
        title: 'Bảo dưỡng xe',
        iconName: 'HugeIcons.strokeRoundedWrench',
        description: 'Sửa chữa, bảo trì, thay lốp.',
      ),
    ],
  ),
  CategoryModel(
    id: 3,
    title: 'Nhà ở',
    iconName: 'HugeIcons.strokeRoundedHome02', // Example icon name
    description: 'Thuê nhà, trả góp, điện nước, sửa chữa nhà.',
    subCategories: [
      CategoryModel(
        id: 301,
        parentId: 3,
        title: 'Thuê nhà/Trả góp',
        iconName: 'HugeIcons.strokeRoundedBuilding01',
        description: 'Tiền thuê nhà hoặc trả góp hàng tháng.',
      ),
      CategoryModel(
        id: 302,
        parentId: 3,
        title: 'Thuế nhà đất',
        iconName: 'HugeIcons.strokeRoundedDocument01',
        description: 'Thuế nhà đất định kỳ.',
      ),
      CategoryModel(
        id: 303,
        parentId: 3,
        title: 'Bảo hiểm nhà',
        iconName: 'HugeIcons.strokeRoundedShield01',
        description: 'Bảo hiểm cho nhà và tài sản.',
      ),
      CategoryModel(
        id: 304,
        parentId: 3,
        title: 'Nội thất & Trang trí',
        iconName: 'HugeIcons.strokeRoundedSofa',
        description: 'Đồ nội thất mới, trang trí nhà cửa.',
      ),
    ],
  ),
  CategoryModel(
    id: 4,
    title: 'Mua sắm',
    iconName: 'HugeIcons.strokeRoundedShoppingBag01', // Example icon name
    description: 'Mua quần áo, đồ điện tử, quà tặng...',
    subCategories: [
      CategoryModel(
        id: 401,
        parentId: 4,
        title: 'Quần áo & Phụ kiện',
        iconName: 'HugeIcons.strokeRoundedTShirt',
        description: 'Quần áo, giày dép, trang sức, túi xách.',
      ),
      CategoryModel(
        id: 402,
        parentId: 4,
        title: 'Đồ điện tử',
        iconName: 'HugeIcons.strokeRoundedSmartphone01',
        description: 'Thiết bị, máy tính, đồ gia dụng.',
      ),
      CategoryModel(
        id: 403,
        parentId: 4,
        title: 'Sở thích & Giải trí',
        iconName: 'HugeIcons.strokeRoundedJoystick01',
        description: 'Đồ cho sở thích, dụng cụ thể thao.',
      ),
    ],
  ),
  CategoryModel(
    id: 5,
    title: 'Giải trí',
    iconName: 'HugeIcons.strokeRoundedCinema', // Example icon name
    description: 'Phim ảnh, ca nhạc, sở thích, đăng ký dịch vụ.',
    subCategories: [
      CategoryModel(
        id: 501,
        parentId: 5,
        title: 'Phim & Sân khấu',
        iconName: 'HugeIcons.strokeRoundedTicket01',
        description: 'Vé xem phim, sân khấu.',
      ),
      CategoryModel(
        id: 502,
        parentId: 5,
        title: 'Hòa nhạc & Sự kiện',
        iconName: 'HugeIcons.strokeRoundedMusicNote01',
        description: 'Nhạc sống, lễ hội, sự kiện thể thao.',
      ),
      CategoryModel(
        id: 503,
        parentId: 5,
        title: 'Dịch vụ xem phim/nghe nhạc',
        iconName: 'HugeIcons.strokeRoundedTv01',
        description: 'Netflix, Spotify, v.v.',
      ),
      CategoryModel(
        id: 504,
        parentId: 5,
        title: 'Trò chơi & Ứng dụng',
        iconName: 'HugeIcons.strokeRoundedGamepad01',
        description: 'Game, ứng dụng, mua trong app.',
      ),
    ],
  ),
  CategoryModel(
    id: 6,
    title: 'Sức khỏe & Làm đẹp',
    iconName: 'HugeIcons.strokeRoundedMedicalCrossCircle', // Example icon name
    description: 'Khám bệnh, thuốc men, phòng gym, v.v.',
    subCategories: [
      CategoryModel(
        id: 601,
        parentId: 6,
        title: 'Bác sĩ & Nha sĩ',
        iconName: 'HugeIcons.strokeRoundedStethoscope',
        description: 'Tư vấn, kiểm tra sức khỏe.',
      ),
      CategoryModel(
        id: 602,
        parentId: 6,
        title: 'Nhà thuốc & Thuốc',
        iconName: 'HugeIcons.strokeRoundedPill',
        description: 'Thuốc kê đơn, thuốc không kê đơn.',
      ),
      CategoryModel(
        id: 603,
        parentId: 6,
        title: 'Gym & Thể hình',
        iconName: 'HugeIcons.strokeRoundedDumbbell',
        description: 'Thẻ tập gym, lớp thể dục.',
      ),
    ],
  ),
  CategoryModel(
    id: 7,
    title: 'Tiện ích',
    iconName: 'HugeIcons.strokeRoundedLightbulb02', // Example icon name
    description: 'Electricity, water, gas, internet, phone bills.',
    subCategories: [
      CategoryModel(
        id: 701,
        parentId: 7,
        title: 'Tiền điện',
        iconName: 'HugeIcons.strokeRoundedFlash',
      ),
      CategoryModel(
        id: 702,
        parentId: 7,
        title: 'Tiền nước',
        iconName: 'HugeIcons.strokeRoundedDrop',
      ),
      CategoryModel(
        id: 703,
        parentId: 7,
        title: 'Tiền gas',
        iconName: 'HugeIcons.strokeRoundedFire',
      ),
      CategoryModel(
        id: 704,
        parentId: 7,
        title: 'Internet & Truyền hình',
        iconName: 'HugeIcons.strokeRoundedWifi',
      ),
      CategoryModel(
        id: 705,
        parentId: 7,
        title: 'Điện thoại di động',
        iconName: 'HugeIcons.strokeRoundedSmartphone02',
      ),
    ],
  ),
  CategoryModel(
    id: 8,
    title: 'Chăm sóc cá nhân',
    iconName: 'HugeIcons.strokeRoundedUser',
    description: 'Haircuts, toiletries, cosmetics.',
    subCategories: [
      CategoryModel(
        id: 801,
        parentId: 8,
        title: 'Cắt tóc & Tạo kiểu',
        iconName: 'HugeIcons.strokeRoundedScissors',
      ),
      CategoryModel(
        id: 802,
        parentId: 8,
        title: 'Đồ dùng cá nhân',
        iconName: 'HugeIcons.strokeRoundedToothbrush',
      ),
      CategoryModel(
        id: 803,
        parentId: 8,
        title: 'Mỹ phẩm & Chăm sóc da',
        iconName: 'HugeIcons.strokeRoundedLipstick',
      ),
    ],
  ),
  CategoryModel(
    id: 9,
    title: 'Giáo dục',
    iconName: 'HugeIcons.strokeRoundedBook', // Example icon name
    description: 'Tuition, books, courses.',
    subCategories: [
      CategoryModel(
        id: 901,
        parentId: 9,
        title: 'Học phí & Lệ phí',
        iconName: 'HugeIcons.strokeRoundedEducation',
      ),
      CategoryModel(
        id: 902,
        parentId: 9,
        title: 'Sách & Vật dụng',
        iconName: 'HugeIcons.strokeRoundedNotebook',
      ),
      CategoryModel(
        id: 903,
        parentId: 9,
        title: 'Khóa học trực tuyến',
        iconName: 'HugeIcons.strokeRoundedLaptop01',
      ),
    ],
  ),
  CategoryModel(
    id: 10,
    title: 'Quà tặng & Quyên góp',
    iconName: 'HugeIcons.strokeRoundedGift', // Example icon name
    description: 'Presents for others, charitable contributions.',
    subCategories: [
      CategoryModel(
        id: 1001,
        parentId: 10,
        title: 'Quà đã tặng',
        iconName: 'HugeIcons.strokeRoundedConfetti',
      ),
      CategoryModel(
        id: 1002,
        parentId: 10,
        title: 'Quyên góp từ thiện',
        iconName: 'HugeIcons.strokeRoundedFavourite',
      ),
    ],
  ),
  CategoryModel(
    id: 11,
    title: 'Travel',
    iconName: 'HugeIcons.strokeRoundedPlane', // Example icon name
    description: 'Flights, hotels, vacation expenses.',
    subCategories: [
      CategoryModel(
        id: 1101,
        parentId: 11,
        title: 'Vé máy bay & Tàu',
        iconName: 'HugeIcons.strokeRoundedDirection01',
      ),
      CategoryModel(
        id: 1102,
        parentId: 11,
        title: 'Chỗ ở',
        iconName: 'HugeIcons.strokeRoundedHotelBed',
      ),
      CategoryModel(
        id: 1103,
        parentId: 11,
        title: 'Hoạt động & Tour',
        iconName: 'HugeIcons.strokeRoundedMap01',
      ),
    ],
  ),
  CategoryModel(
    id: 12,
    title: 'Trẻ em',
    iconName: 'HugeIcons.strokeRoundedBaby', // Example icon name
    description: 'Childcare, toys, school supplies for children.',
    subCategories: [
      CategoryModel(
        id: 1201,
        parentId: 12,
        title: 'Chăm sóc trẻ',
        iconName: 'HugeIcons.strokeRoundedUserGroup',
      ),
      CategoryModel(
        id: 1202,
        parentId: 12,
        title: 'Đồ chơi & Trò chơi',
        iconName: 'HugeIcons.strokeRoundedPuzzle',
      ),
      CategoryModel(
        id: 1203,
        parentId: 12,
        title: 'Trường học & Dụng cụ',
        iconName: 'HugeIcons.strokeRoundedBackpack',
      ),
    ],
  ),
  CategoryModel(
    id: 13,
    title: 'Thú cưng',
    iconName: 'HugeIcons.strokeRoundedPaw', // Example icon name
    description: 'Pet food, vet visits, pet supplies.',
    subCategories: [
      CategoryModel(
        id: 1301,
        parentId: 13,
        title: 'Thức ăn cho thú cưng',
        iconName: 'HugeIcons.strokeRoundedBowl',
      ),
      CategoryModel(
        id: 1302,
        parentId: 13,
        title: 'Thú y & Y tế',
        iconName: 'HugeIcons.strokeRoundedMedicalFile01',
      ),
      CategoryModel(
        id: 1303,
        parentId: 13,
        title: 'Đồ chơi & Phụ kiện',
        iconName: 'HugeIcons.strokeRoundedDog',
      ),
    ],
  ),
  CategoryModel(
    id: 14,
    title: 'Chi phí công việc',
    iconName: 'HugeIcons.strokeRoundedBriefcase01', // Example icon name
    description: 'Work-related expenses, office supplies.',
    subCategories: [
      CategoryModel(
        id: 1401,
        parentId: 14,
        title: 'Văn phòng phẩm',
        iconName: 'HugeIcons.strokeRoundedPen',
      ),
      CategoryModel(
        id: 1402,
        parentId: 14,
        title: 'Phần mềm & Đăng ký',
        iconName: 'HugeIcons.strokeRoundedCloudSoftware',
      ),
      CategoryModel(
        id: 1403,
        parentId: 14,
        title: 'Công tác',
        iconName: 'HugeIcons.strokeRoundedSuitcase',
      ),
    ],
  ),
  CategoryModel(
    id: 15,
    title: 'Đầu tư',
    iconName: 'HugeIcons.strokeRoundedChartCandlestick', // Example icon name
    description: 'Stocks, bonds, mutual funds.',
    subCategories: [
      CategoryModel(
        id: 1501,
        parentId: 15,
        title: 'Cổ phiếu',
        iconName: 'HugeIcons.strokeRoundedChartTrendingUp01',
      ),
      CategoryModel(
        id: 1502,
        parentId: 15,
        title: 'Trái phiếu',
        iconName: 'HugeIcons.strokeRoundedDocumentCertificate',
      ),
      CategoryModel(
        id: 1503,
        parentId: 15,
        title: 'Quỹ đầu tư',
        iconName: 'HugeIcons.strokeRoundedChartPie01',
      ),
    ],
  ),
  CategoryModel(
    id: 16,
    title: 'Tiết kiệm',
    iconName: 'HugeIcons.strokeRoundedBank', // Example icon name
    description: 'Contributions to savings accounts.',
    subCategories: [
      CategoryModel(
        id: 1601,
        parentId: 16,
        title: 'Quỹ khẩn cấp',
        iconName: 'HugeIcons.strokeRoundedLifebuoy',
      ),
      CategoryModel(
        id: 1602,
        parentId: 16,
        title: 'Quỹ hưu trí',
        iconName: 'HugeIcons.strokeRoundedUmbrella',
      ),
      CategoryModel(
        id: 1603,
        parentId: 16,
        title: 'Tiết kiệm chung',
        iconName: 'HugeIcons.strokeRoundedPiggyBank01',
      ),
    ],
  ),
  CategoryModel(
    id: 17, // Typically income is handled differently, but can be a category
    title: 'Thu nhập',
    iconName: 'HugeIcons.strokeRoundedReceiveDollars', // Example icon name
    description: 'Salary, wages, freelance income.',
    subCategories: [
      CategoryModel(
        id: 1701,
        parentId: 17,
        title: 'Lương/Thù lao',
        iconName: 'HugeIcons.strokeRoundedDollar',
      ),
      CategoryModel(
        id: 1702,
        parentId: 17,
        title: 'Tự do/Tư vấn',
        iconName: 'HugeIcons.strokeRoundedBriefcase02',
      ),
      CategoryModel(
        id: 1703,
        parentId: 17,
        title: 'Thu nhập đầu tư',
        iconName: 'HugeIcons.strokeRoundedChartBar02',
      ),
      CategoryModel(
        id: 1704,
        parentId: 17,
        title: 'Thưởng',
        iconName: 'HugeIcons.strokeRoundedAward01',
      ),
    ],
  ),
  CategoryModel(
    id: 18,
    title: 'Khác',
    iconName: 'HugeIcons.strokeRoundedGridSmall', // Example icon name
    description: 'Other uncategorized expenses.',
    subCategories: [
      CategoryModel(
        id: 1801,
        parentId: 18,
        title: 'Phí ngân hàng',
        iconName: 'HugeIcons.strokeRoundedCreditCard01',
      ),
      CategoryModel(
        id: 1802,
        parentId: 18,
        title: 'Thuế (khác)',
        iconName: 'HugeIcons.strokeRoundedCalculator',
      ),
      CategoryModel(
        id: 1803,
        parentId: 18,
        title: 'Chi phí khác',
        iconName: 'HugeIcons.strokeRoundedMore01',
      ),
    ],
  ),
];

extension CategoriesExtension on List<CategoryModel> {
  /// Returns a flat list of all categories, including sub-categories.
  List<CategoryModel> getAllCategories() {
    final List<CategoryModel> allCategories = [];
    // Helper function to recursively add categories
    void addCategoriesRecursively(List<CategoryModel>? categoryList) {
      if (categoryList == null) return;
      for (final category in categoryList) {
        allCategories.add(category);
        if (category.hasSubCategories) {
          addCategoriesRecursively(category.subCategories);
        }
      }
    }

    addCategoriesRecursively(
      this,
    ); // 'this' refers to the list of top-level categories
    return allCategories;
  }
}
