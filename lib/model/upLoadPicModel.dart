class UpLoadPicModel {
  String result;
  String code;
  FileUpload fileUpload;
  String message;

  UpLoadPicModel({this.result, this.code, this.fileUpload, this.message});

  UpLoadPicModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    code = json['code'];
    fileUpload = json['fileUpload'] != null
        ? new FileUpload.fromJson(json['fileUpload'])
        : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['code'] = this.code;
    if (this.fileUpload != null) {
      data['fileUpload'] = this.fileUpload.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class FileUpload {
  String id;
  bool isNewRecord;
  String updateBy;
  String updateByName;
  String createBy;
  String updateDate;
  String status;
  String createDate;
  String createByName;
  String fileName;
  String fileType;
  FileEntity fileEntity;
  String fileUrl;

  FileUpload(
      {this.id,
      this.isNewRecord,
      this.updateBy,
      this.updateByName,
      this.createBy,
      this.updateDate,
      this.status,
      this.createDate,
      this.createByName,
      this.fileName,
      this.fileType,
      this.fileEntity,
      this.fileUrl});

  FileUpload.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isNewRecord = json['isNewRecord'];
    updateBy = json['updateBy'];
    updateByName = json['updateByName'];
    createBy = json['createBy'];
    updateDate = json['updateDate'];
    status = json['status'];
    createDate = json['createDate'];
    createByName = json['createByName'];
    fileName = json['fileName'];
    fileType = json['fileType'];
    fileEntity = json['fileEntity'] != null
        ? new FileEntity.fromJson(json['fileEntity'])
        : null;
    fileUrl = json['fileUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['isNewRecord'] = this.isNewRecord;
    data['updateBy'] = this.updateBy;
    data['updateByName'] = this.updateByName;
    data['createBy'] = this.createBy;
    data['updateDate'] = this.updateDate;
    data['status'] = this.status;
    data['createDate'] = this.createDate;
    data['createByName'] = this.createByName;
    data['fileName'] = this.fileName;
    data['fileType'] = this.fileType;
    if (this.fileEntity != null) {
      data['fileEntity'] = this.fileEntity.toJson();
    }
    data['fileUrl'] = this.fileUrl;
    return data;
  }
}

class FileEntity {
  String id;
  bool isNewRecord;
  String updateBy;
  String updateByName;
  String createBy;
  String updateDate;
  String status;
  String createDate;
  String createByName;
  String fileMeta;
  String fileId;
  FileMetaMap fileMetaMap;
  String fileExtension;
  int fileSize;
  String filePath;
  String fileContentType;
  String fileMd5;
  String fileSizeFormat;

  FileEntity(
      {this.id,
      this.isNewRecord,
      this.updateBy,
      this.updateByName,
      this.createBy,
      this.updateDate,
      this.status,
      this.createDate,
      this.createByName,
      this.fileMeta,
      this.fileId,
      this.fileMetaMap,
      this.fileExtension,
      this.fileSize,
      this.filePath,
      this.fileContentType,
      this.fileMd5,
      this.fileSizeFormat});

  FileEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isNewRecord = json['isNewRecord'];
    updateBy = json['updateBy'];
    updateByName = json['updateByName'];
    createBy = json['createBy'];
    updateDate = json['updateDate'];
    status = json['status'];
    createDate = json['createDate'];
    createByName = json['createByName'];
    fileMeta = json['fileMeta'];
    fileId = json['fileId'];
    fileMetaMap = json['fileMetaMap'] != null
        ? new FileMetaMap.fromJson(json['fileMetaMap'])
        : null;
    fileExtension = json['fileExtension'];
    fileSize = json['fileSize'];
    filePath = json['filePath'];
    fileContentType = json['fileContentType'];
    fileMd5 = json['fileMd5'];
    fileSizeFormat = json['fileSizeFormat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['isNewRecord'] = this.isNewRecord;
    data['updateBy'] = this.updateBy;
    data['updateByName'] = this.updateByName;
    data['createBy'] = this.createBy;
    data['updateDate'] = this.updateDate;
    data['status'] = this.status;
    data['createDate'] = this.createDate;
    data['createByName'] = this.createByName;
    data['fileMeta'] = this.fileMeta;
    data['fileId'] = this.fileId;
    if (this.fileMetaMap != null) {
      data['fileMetaMap'] = this.fileMetaMap.toJson();
    }
    data['fileExtension'] = this.fileExtension;
    data['fileSize'] = this.fileSize;
    data['filePath'] = this.filePath;
    data['fileContentType'] = this.fileContentType;
    data['fileMd5'] = this.fileMd5;
    data['fileSizeFormat'] = this.fileSizeFormat;
    return data;
  }
}

class FileMetaMap {
  int width;
  int height;

  FileMetaMap({this.width, this.height});

  FileMetaMap.fromJson(Map<String, dynamic> json) {
    width = json['width'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['width'] = this.width;
    data['height'] = this.height;
    return data;
  }
}
