part of 'app.dart';

class _ButtonView extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const _ButtonView({required this.onPressed, required this.title});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: MaterialButton(
        onPressed: onPressed,
        child: Text(title),
      ),
    );
  }
}
