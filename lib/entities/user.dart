class User {
  
  final int id;
  final String avatarUrl;
  final String login;
  final String htmlUrl;

  User ({this.id, this.avatarUrl, this.login, this.htmlUrl});

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json['id'],
      avatarUrl: json['avatar_url'],
      login: json['login'],
      htmlUrl: json['html_url']
    );
  }

}