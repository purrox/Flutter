class Repos{
  final int id;
  final String name;
  final String description;

  Repos({this.id, this.name, this.description});

  factory Repos.fromJson(Map<String, dynamic> json){
    return Repos(
      id: json['id'],
      name: json['full_name'],
      description: json['description']
    );
  }
}