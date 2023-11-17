import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    //프로바이더로 감싸야 됨
    ProviderScope(
      child: MyApp(),
    ),
  );
}

int num = 1;
//창고 데이터
//관리하기편해서

class Model {
  int num;
  Model(this.num);
}

//창고 class(상태,행위) (provider -상태, statenotifierProvider -상태 +메서드)
//부모가 널을 관리
//얘가 관리하는 상태의 타입을 적어주면 됨
class ViewModel extends StateNotifier<Model?> {
  //:은 생성자가 실행되기 전에 먼저 실향됨
  ViewModel(super.state);

  //창고 초기값
  void init() {
    //통신코드 ,상태를바꿔줘야 됨
    state = Model(1);
  }

  //스테이트 자체가 모델 ,모델을 변경하면 안되고 스테이트값을 가져와서
  //그걸 바꿔줘야됨 (상태값)
  void change() {
    state = Model(2);
  }
}

//창고관리자 <창고이름, 창고데이터타입> ,창고가 꼭 필요함
//뷰모델에다가 널을 날리고 이닛으로 통신코드를 넘길거야
final numProvider = StateNotifierProvider<ViewModel, Model?>((ref) {
  return ViewModel(null)..init();
  //화면이 그려질 때 초기값을 정해줘야 됨
});

//창고 , 안에있는것들이 창고데이터
class People {
  int age;
  String name;
  People(this.age, this.name);
}

final peopleProvider = Provider(
  (ref) {
    return num;
  },
);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              MyText1(),
              MyText2(),
              MyText3(),
              MuButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class MuButton extends ConsumerWidget {
  const MuButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
        onPressed: () {
          //창고에 접근이 가능함
          ref.read(numProvider.notifier).change();
        },
        child: Text("상태변경"));
  }
}

class MyText3 extends StatelessWidget {
  const MyText3({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text("5", style: TextStyle(fontSize: 30));
  }
}

class MyText2 extends ConsumerWidget {
  const MyText2({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Model? model = ref.watch(numProvider);

    if (model == null) {
      return CircularProgressIndicator();
    } else {
      return Text("${model.num}", style: TextStyle(fontSize: 30));
    }
  }
}

//수신하고싶은 곳만 와치만 하면ㄷ함
class MyText1 extends ConsumerWidget {
  const MyText1({
    super.key,
  });

  //위젯은 프로바이더(한번하고 변경할 필요 없을 때)에 접근하는 참조변수 ,컨슈머 위젯해야지 위젯 ref적을 수 있음
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref가 필요함 ㅜ
    Model? model = ref.watch(numProvider);

    if (model == null) {
      return CircularProgressIndicator();
    } else {
      return Text("${model.num}", style: TextStyle(fontSize: 30));
    }
  }
}
