class MyState{
  int id;
  String state;
  MyState({this.id,this.state});

  List get states=> _getStates();

  _getStates(){
    List stateList= [
      MyState(id:1,state:'Abia State'),
      MyState(id:2,state: 'Abuja FCT'),
      MyState(id:3,state:'Adamawa State'),
      MyState(id:4,state:'Akwa Ibom State'),
      MyState(id:5,state:'Anambra State'),
      MyState(id:6,state:'Bauchi State'),
      MyState(id:7,state:'Bayelsa State'),
      MyState(id:8,state:'Benue State',),
      MyState(id:10,state:'Cross River State'),
      MyState(id:11,state:'Delta State'),
      MyState(id:12,state:'Ebonyi State'),
      MyState(id:13,state:'Edo State'),
      MyState(id:14,state:'Ekiti State'),
      MyState(id:15,state:'Enugu State'),
      MyState(id:16,state:'Gombe State'),
      MyState(id:17,state:'Imo State'),
      MyState(id:18,state:'Jigawa State'),
      MyState(id:19,state:'Kaduna State'),
      MyState(id:20,state:'Kano State'),
      MyState(id:21,state:'Katsina State'),
      MyState(id:22,state:'Kebbi State'),
      MyState(id:23,state:'Kogi State'),
      MyState(id:24,state:'Kwara State'),
      MyState(id:25,state:'Lagos State'),
      MyState(id:26,state:'Nasarawa State'),
      MyState(id:27,state:'Niger State'),
      MyState(id:28,state:'Ogun State'),
      MyState(id:29,state:'Ondo State'),
      MyState(id:30,state:'Osun State'),
      MyState(id:31,state:'Oyo State'),
      MyState(id:32,state:'Plateau State'),
      MyState(id:33,state:'Rivers State'),
      MyState(id:34,state:'Sokoto State'),
      MyState(id:35,state:'Taraba State'),
      MyState(id:36,state:'Yobe State'),
      MyState(id:37,state:'Zamfara State'),
//      MyState(id:38,state:""),
    ];
    return stateList;

  }




}