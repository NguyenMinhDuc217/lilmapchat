class Video {
  final String name;
  final String url;
  final String thumbnail;

  const Video({
    required this.name,
    required this.url,
    required this.thumbnail,
  });
}

const videos = [
  Video(
    name: 'Trước khi em tồn tại',
    url:
        'https://media.istockphoto.com/id/818253290/vi/video/m%C3%B9a-h%C3%A8-%E1%BB%9F-appalachia.mp4?s=mp4-640x640-is&k=20&c=VLPlhLmzTZHmOmdonHgdOOGSu49wcyo7psAyedxowok=',
    thumbnail: 'https://i.ytimg.com/vi/NfqM4BMuO8Y/hqdefault.jpg',
  ),
  Video(
    name: 'Ngày em đẹp nhất',
    url:
        'https://media.istockphoto.com/id/1477901205/vi/video/nh%C3%ACn-th%E1%BA%A5y-b%C3%AAn-trong-mi%E1%BB%87ng-n%C3%BAi-l%E1%BB%ADa-v%E1%BB%9Bi-kh%C3%B3i-%E1%BB%9F-ph%C3%ADa-t%C3%A2y-java.mp4?s=mp4-640x640-is&k=20&c=RGIF6wD5sN36BIHvsSDIFxyHwosQKMNxdVo3bwdXDH4=',
    thumbnail:
        'https://static2.vieon.vn/vieplay-image/carousel_web_v4/2022/01/04/uod0qt3e_1920x1080-ngayemdepnhat_1920_1080.jpg',
  ),
  Video(
    name: 'She neva knows',
    url:
        'https://media.istockphoto.com/id/1214503058/vi/video/n%E1%BB%AF-ng%C6%B0%E1%BB%9Di-%C4%91i-b%E1%BB%99-%C4%91%C6%B0%E1%BB%9Dng-d%C3%A0i-tr%C3%AAn-m%E1%BB%99t-chuy%E1%BA%BFn-%C4%91i-b%E1%BB%99-trong-r%E1%BB%ABng.mp4?s=mp4-640x640-is&k=20&c=55G5d2iTQqXGivYO37tjdmOw62HHgQciEX6IRbg_Pt8=',
    thumbnail:
        'https://nhachot.vn/wp-content/uploads/2020/01/loi-bai-hat-she-neva-knows-justatee-lyrics-kem-hop-am-1.jpg',
  ),
];
