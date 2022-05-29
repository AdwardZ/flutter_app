import 'package:flutterappdemo/utils/offline_utils.dart';

class HomeResModel {
  String userId;
  String userName;
  String roleName;

  List<AppSite> appSites;

  HomeResModel({this.userId, this.userName, this.roleName, this.appSites});

  HomeResModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userName = json['userName'];
    roleName = json['roleName'];

    if (json['appSites'] != null) {
      appSites = new List<AppSite>();
      json['appSites'].forEach((v) {
        AppSite dirSite = new AppSite.fromJson(v);
        //print("HomeResModel.siteId=" + '${dirSite.siteId}' + ",comments=" + '${dirSite.dirTwos.first.dirThrees.first.comments}');
        appSites.add(dirSite);
        //appSites.add(new AppSite.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['userName'] = this.userName;
    data['roleName'] = this.roleName;
    if (this.appSites != null) {
      data['appSites'] = this.appSites.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AppSite {
  int uploadedNumber;// 已上传到服务器的图片和文档数量
  int specifiedNumber;// 规定需要上传的图片和文档数量
  String siteId;
  // 1-No photos 无照片(服务端没有照片)
  // 2-Upload completed 照片均已上传完成(审核已通过)
  // 3-Offline photos 存在离线照片，这个状态需要APP客户端来判断

  // 1-To be uploaded 待上传
  // 2-To be approved 待审核
  // 3-Under approve
  // 4-Accepted 审核通过
  // 5-Rejected 审核不通过
  int uploadStatus;// 1-No photos,2-Upload completed,3-Offline photos
  int approveStatus;
  int needUploadNumber;// 本地还未上传到服务器的图片和文档数量
  List<DirOne> dirOnes;

  AppSite(
      {this.uploadedNumber, this.specifiedNumber, this.siteId, this.dirOnes});

  AppSite.fromJson(Map<String, dynamic> json) {
    uploadedNumber = json['uploadedNumber'];
    specifiedNumber = json['specifiedNumber'];
    uploadStatus = json['uploadStatus'] ?? 1;
    approveStatus = json['approveStatus'] ?? 1;
    siteId = json['siteId'];
    if (json['dirOnes'] != null) {
      dirOnes = new List<DirOne>();
      json['dirOnes'].forEach((v) {
        DirOne dirOne = new DirOne.fromJson(v);
        //print("AppSites.siteId=" + '$siteId' + ",comments=" + '${dirOne.dirTwos.first.comments}');
        dirOnes.add(dirOne);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uploadedNumber'] = this.uploadedNumber;
    data['specifiedNumber'] = this.specifiedNumber;
    data['uploadStatus'] = this.uploadStatus;
    data['approveStatus'] = this.approveStatus;
    data['siteId'] = this.siteId;
    if (this.dirOnes != null) {
      data['dirOnes'] = this.dirOnes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DirOne {
  int uploadedNumber;
  int specifiedNumber;
  String name;
  String bizKey;
  int uploadStatus;
  int approveStatus;
  List<DirTwo> dirTwos;
  int needUploadNumber = 0;

  ///自加字段
  String siteId;

  DirOne(
      {this.uploadedNumber,
      this.specifiedNumber,
      this.name,
      this.bizKey,
      this.uploadStatus,
      this.approveStatus,
      this.dirTwos});

  DirOne.fromJson(Map<String, dynamic> json) {
    uploadedNumber = json['uploadedNumber'];
    specifiedNumber = json['specifiedNumber'];
    name = json['name'];
    bizKey = json['bizKey'];
    uploadStatus = json['uploadStatus'];
    approveStatus = json['approveStatus'];
    if (json['dirTwos'] != null) {
      dirTwos = new List<DirTwo>();
      json['dirTwos'].forEach((v) {
        DirTwo dirTwo = new DirTwo.fromJson(v);
        //print("dirTwo.bizKey=" + '$bizKey' + ",comments=" + '${dirTwo.comments}');
        dirTwos.add(dirTwo);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uploadedNumber'] = this.uploadedNumber;
    data['specifiedNumber'] = this.specifiedNumber;
    data['name'] = this.name;
    data['bizKey'] = this.bizKey;
    data['uploadStatus'] = this.uploadStatus;
    data['approveStatus'] = this.approveStatus;
    if (this.dirTwos != null) {
      data['dirTwos'] = this.dirTwos.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DirTwo {
  int uploadedNumber;
  int specifiedNumber;
  String name;
  String bizKey;
  int uploadStatus;
  int approveStatus;
  List<DirThree> dirThrees;
  int needUploadNumber = 0;

  ///自加字段
  String siteId;
  String dirOneId;
  String dirOneName;

  DirTwo(
      {this.uploadedNumber,
        this.specifiedNumber,
        this.name,
        this.bizKey,
        this.uploadStatus,
        this.approveStatus,
        this.dirThrees});

  DirTwo.fromJson(Map<String, dynamic> json) {
    uploadedNumber = json['uploadedNumber'];
    specifiedNumber = json['specifiedNumber'];
    name = json['name'];
    bizKey = json['bizKey'];
    uploadStatus = json['uploadStatus'];
    approveStatus = json['approveStatus'];
    if (json['dirThrees'] != null) {
      dirThrees = new List<DirThree>();
      json['dirThrees'].forEach((v) {
        DirThree dirThree = new DirThree.fromJson(v);
        //print("dirThree.bizKey=" + '$bizKey' + ",comments=" + '${dirThree.comments}');
        dirThrees.add(dirThree);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uploadedNumber'] = this.uploadedNumber;
    data['specifiedNumber'] = this.specifiedNumber;
    data['name'] = this.name;
    data['bizKey'] = this.bizKey;
    data['uploadStatus'] = this.uploadStatus;
    data['approveStatus'] = this.approveStatus;
    if (this.dirThrees != null) {
      data['dirThrees'] = this.dirThrees.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DirThree {
  String bizKey;
  String name;
  int type;// 1-Photo 2-Document 3-Photo&Document
  int uploadedNumber;
  int specifiedNumber;
  int uploadStatus;
  int approveStatus;
  int needUploadNumber = 0;
  String exampleNote;
  String comments;
  List<UploadedPicUrls> uploadedPicUrls;
  List<ExamplePicUrls> examplePicUrls;
  List<String> uploadedFileUrls;

  ///自加字段
  String siteId;
  String dirOneId;
  String dirOneName;
  String dirTwoId;
  String dirTwoName;

  DirThree(
      {this.uploadedNumber,
      this.specifiedNumber,
      this.name,
      this.bizKey,
      this.uploadedPicUrls,
      this.examplePicUrls,
      this.exampleNote,
      this.uploadedFileUrls,
      this.comments});

  DirThree.fromJson(Map<String, dynamic> json) {
    //print("DirThrees.json=" + '$json');
    uploadedNumber = json['uploadedNumber'];
    specifiedNumber = json['specifiedNumber'];
    name = json['name'];
    bizKey = json['bizKey'];
    uploadStatus = json['uploadStatus'];
    approveStatus = json['approveStatus'];
    exampleNote = json['exampleNote'];
    comments = json['comments'];
    type = json['type'];
    //print("DirThrees.bizKey=" + '$bizKey' + ",comments=" + '$comments');
    uploadedFileUrls = json['uploadedFileUrls'].cast<String>();
    if (json['uploadedPicUrls'] != null) {
      uploadedPicUrls = new List<UploadedPicUrls>();
      json['uploadedPicUrls'].forEach((v) {
        uploadedPicUrls.add(new UploadedPicUrls.fromJson(v));
      });
    }
    if (json['examplePicUrls'] != null) {
      examplePicUrls = new List<ExamplePicUrls>();
      json['examplePicUrls'].forEach((v) {
        examplePicUrls.add(new ExamplePicUrls.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uploadedNumber'] = this.uploadedNumber;
    data['specifiedNumber'] = this.specifiedNumber;
    data['name'] = this.name;
    data['bizKey'] = this.bizKey;
    data['uploadStatus'] = this.uploadStatus;
    data['approveStatus'] = this.approveStatus;
    data['exampleNote'] = this.exampleNote;
    data['comments'] = this.comments;
    data['type'] = this.type;
    if (this.uploadedPicUrls != null) {
      data['uploadedPicUrls'] = this.uploadedPicUrls.map((v) => v.toJson()).toList();
    }
    if (this.examplePicUrls != null) {
      data['examplePicUrls'] = this.examplePicUrls.map((v) => v.toJson()).toList();
    }
    data['uploadedFileUrls'] = this.uploadedFileUrls;
    return data;
  }
}

class UploadedPicUrls {
  String id;
  String fileName;
  String fileUrl;
  int sort;
  String filePath;

  UploadedPicUrls(
      {this.id, this.fileName, this.fileUrl, this.sort, this.filePath});

  UploadedPicUrls.fromJson(Map<String, dynamic> json) {
    fileName = json['fileName'];
    fileUrl = json['fileUrl'];
    id = json['id'];
    sort = json['sort'];
    filePath = json['filePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fileName'] = this.fileName;
    data['fileUrl'] = this.fileUrl;
    data['id'] = this.id;
    data['sort'] = this.sort;
    data['filePath'] = this.filePath;
    return data;
  }
}

class ExamplePicUrls {
  String id;
  String fileName;
  String fileUrl;
  int sort;
  String filePath;

  ExamplePicUrls(
      {this.id, this.fileName, this.fileUrl, this.sort, this.filePath});

  ExamplePicUrls.fromJson(Map<String, dynamic> json) {
    fileName = json['fileName'];
    fileUrl = json['fileUrl'];
    id = json['id'];
    sort = json['sort'];
    filePath = json['filePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fileName'] = this.fileName;
    data['fileUrl'] = this.fileUrl;
    data['id'] = this.id;
    data['sort'] = this.sort;
    data['filePath'] = this.filePath;
    return data;
  }
}
