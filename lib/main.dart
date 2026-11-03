import 'dart:ui';
import 'package:flutter/material.dart';

void main() => runApp(const NeShtatApp());

class NeShtatApp extends StatelessWidget {
  const NeShtatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'НЕ ШТАТ Auto Cockpit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF090B14),
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF9B8CFF),
          brightness: Brightness.dark,
        ),
      ),
      home: const CockpitDashboard(),
    );
  }
}

class CockpitDashboard extends StatelessWidget {
  const CockpitDashboard({super.key});

  static const accent = Color(0xFFB5A7FF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const _AmbientBackground(),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth > constraints.maxHeight;
                return Padding(
                  padding: EdgeInsets.all(wide ? 22 : 18),
                  child: wide ? _wideLayout(context) : _tallLayout(context),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _header() => Row(
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('НЕ ШТАТ', style: TextStyle(
                fontSize: 12, letterSpacing: 3.2, fontWeight: FontWeight.w800,
                color: Color(0xFFBDB3FF))),
              SizedBox(height: 3),
              Text('AUTO COCKPIT', style: TextStyle(
                fontSize: 10, letterSpacing: 2.4, color: Colors.white54)),
            ],
          ),
          const Spacer(),
          _roundIcon(Icons.bluetooth_connected, 'Bluetooth'),
          const SizedBox(width: 10),
          _roundIcon(Icons.tune_rounded, 'Настройки'),
        ],
      );

  Widget _tallLayout(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          const SizedBox(height: 26),
          const _ClockBlock(),
          const SizedBox(height: 20),
          const _MusicCard(),
          const SizedBox(height: 14),
          const Row(children: [
            Expanded(child: _QuickCard(icon: Icons.navigation_rounded, title: 'Навигация', subtitle: 'Яндекс Навигатор', tint: Color(0xFF7DA8FF))),
            SizedBox(width: 12),
            Expanded(child: _QuickCard(icon: Icons.cloud_rounded, title: 'Погода', subtitle: 'Нет данных', tint: Color(0xFF8BD8E8))),
          ]),
          const SizedBox(height: 14),
          const Row(children: [
            Expanded(child: _QuickCard(icon: Icons.mic_rounded, title: 'Помощник', subtitle: 'Алиса / ChatGPT', tint: Color(0xFFB5A7FF))),
            SizedBox(width: 12),
            Expanded(child: _QuickCard(icon: Icons.battery_5_bar_rounded, title: 'Телефон', subtitle: 'Состояние устройства', tint: Color(0xFF8BD6B0))),
          ]),
          const Spacer(),
          const _BottomBar(),
        ],
      );

  Widget _wideLayout(BuildContext context) => Column(
        children: [
          _header(),
          const SizedBox(height: 20),
          Expanded(
            child: Row(
              children: [
                const Expanded(flex: 5, child: _NavigationCard()),
                const SizedBox(width: 16),
                Expanded(
                  flex: 4,
                  child: Column(
                    children: const [
                      Expanded(child: _ClockBlock()),
                      SizedBox(height: 14),
                      Expanded(child: _MusicCard()),
                      SizedBox(height: 14),
                      Row(children: [
                        Expanded(child: _QuickCard(icon: Icons.cloud_rounded, title: 'Погода', subtitle: 'Нет данных', tint: Color(0xFF8BD8E8))),
                        SizedBox(width: 12),
                        Expanded(child: _QuickCard(icon: Icons.mic_rounded, title: 'Помощник', subtitle: 'Алиса / ChatGPT', tint: Color(0xFFB5A7FF))),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const _BottomBar(),
        ],
      );

  static Widget _roundIcon(IconData icon, String label) => Tooltip(
        message: label,
        child: Container(
          width: 42, height: 42,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.07),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white.withOpacity(.09)),
          ),
          child: Icon(icon, size: 19, color: Colors.white70),
        ),
      );
}

class _AmbientBackground extends StatelessWidget {
  const _AmbientBackground();

  @override
  Widget build(BuildContext context) => Positioned.fill(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [Color(0xFF17172B), Color(0xFF0B1020), Color(0xFF080A11)],
            ),
          ),
          child: Stack(children: [
            Positioned(top: -130, right: -80, child: _glow(290, const Color(0xFF6656C8))),
            Positioned(bottom: -180, left: -100, child: _glow(330, const Color(0xFF245B83))),
          ]),
        ),
      );

  Widget _glow(double size, Color color) => ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 75, sigmaY: 75),
        child: Container(
          width: size, height: size,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color.withOpacity(.42)),
        ),
      );
}

class _Glass extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final double radius;
  const _Glass({required this.child, this.padding = const EdgeInsets.all(18), this.radius = 25});

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.075),
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(color: Colors.white.withOpacity(.12)),
            ),
            child: child,
          ),
        ),
      );
}

class _ClockBlock extends StatelessWidget {
  const _ClockBlock();

  @override
  Widget build(BuildContext context) => _Glass(
        child: Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('ДОБРО ПОЖАЛОВАТЬ', style: TextStyle(fontSize: 10, letterSpacing: 2.2, color: Colors.white54)),
                  SizedBox(height: 5),
                  Text('--:--', style: TextStyle(fontSize: 48, height: 1, fontWeight: FontWeight.w300, letterSpacing: -2)),
                  SizedBox(height: 7),
                  Text('Вторник  •  3 ноября', style: TextStyle(fontSize: 13, color: Colors.white60)),
                ],
              ),
            ),
            Container(
              width: 58, height: 58,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFB5A7FF).withOpacity(.13),
                border: Border.all(color: const Color(0xFFB5A7FF).withOpacity(.3)),
              ),
              child: const Icon(Icons.wb_twilight_rounded, color: Color(0xFFB5A7FF), size: 27),
            ),
          ],
        ),
      );
}

class _MusicCard extends StatelessWidget {
  const _MusicCard();

  @override
  Widget build(BuildContext context) => _Glass(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 58, height: 58,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(colors: [Color(0xFF8B75D8), Color(0xFF263B69)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              ),
              child: const Icon(Icons.music_note_rounded, size: 29, color: Colors.white),
            ),
            const SizedBox(width: 14),
            const Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('СЕЙЧАС ИГРАЕТ', style: TextStyle(fontSize: 9, letterSpacing: 1.8, color: Colors.white54)),
                SizedBox(height: 5),
                Text('Нет активного трека', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                SizedBox(height: 3),
                Text('Подключи музыкальное приложение', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11, color: Colors.white54)),
              ],
            )),
            const SizedBox(width: 8),
            const Icon(Icons.skip_previous_rounded, color: Colors.white70, size: 25),
            const SizedBox(width: 8),
            Container(
              width: 42, height: 42,
              decoration: const BoxDecoration(color: Color(0xFFB5A7FF), shape: BoxShape.circle),
              child: const Icon(Icons.play_arrow_rounded, color: Color(0xFF171426), size: 26),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.skip_next_rounded, color: Colors.white70, size: 25),
          ],
        ),
      );
}

class _QuickCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color tint;
  const _QuickCard({required this.icon, required this.title, required this.subtitle, required this.tint});

  @override
  Widget build(BuildContext context) => _Glass(
        padding: const EdgeInsets.all(16),
        radius: 22,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: tint, size: 23),
            const SizedBox(height: 15),
            Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, color: Colors.white54)),
          ],
        ),
      );
}

class _NavigationCard extends StatelessWidget {
  const _NavigationCard();

  @override
  Widget build(BuildContext context) => _Glass(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(children: [
              Icon(Icons.navigation_rounded, color: Color(0xFF8FB2FF)),
              SizedBox(width: 9),
              Text('НАВИГАЦИЯ', style: TextStyle(fontSize: 11, letterSpacing: 2, color: Colors.white70)),
              Spacer(),
              Icon(Icons.open_in_new_rounded, size: 17, color: Colors.white54),
            ]),
            const Spacer(),
            Center(child: Icon(Icons.map_outlined, size: 76, color: Colors.white.withOpacity(.13))),
            const SizedBox(height: 10),
            const Center(child: Text('Маршрут появится здесь', style: TextStyle(color: Colors.white54, fontSize: 13))),
            const Spacer(),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(color: const Color(0xFF8FB2FF).withOpacity(.14), borderRadius: BorderRadius.circular(16)),
              child: const Center(child: Text('ОТКРЫТЬ ЯНДЕКС НАВИГАТОР', style: TextStyle(fontSize: 10, letterSpacing: 1.2, color: Color(0xFFB9CCFF), fontWeight: FontWeight.w700))),
            ),
          ],
        ),
      );
}

class _BottomBar extends StatelessWidget {
  const _BottomBar();

  @override
  Widget build(BuildContext context) => Row(
        children: [
          const Icon(Icons.directions_car_filled_rounded, color: Color(0xFFB5A7FF), size: 17),
          const SizedBox(width: 8),
          const Text('COCKPIT', style: TextStyle(fontSize: 10, letterSpacing: 2, color: Colors.white54)),
          const Spacer(),
          Text('V 0.1.0  •  CONCEPT BUILD', style: TextStyle(fontSize: 9, letterSpacing: 1.2, color: Colors.white.withOpacity(.35))),
        ],
      );
}
