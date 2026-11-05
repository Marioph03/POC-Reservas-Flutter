import 'package:flutter/material.dart';

void main() => runApp(const PocReservasBarberiaApp());

class PocReservasBarberiaApp extends StatelessWidget {
  const PocReservasBarberiaApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'POC Reservas Barbería',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFFF6A3D),
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: const Color(0xFFF8F7F5),
        ),
        home: const DashboardPage(),
      );
}

class Booking {
  Booking(this.time, this.client, this.service, this.barber, this.color,
      {this.status = 'Confirmada'});
  final String time, client, service, barber;
  final Color color;
  String status;
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int section = 0;
  DateTime selectedDay = DateTime(2026, 11, 5);
  final bookings = <Booking>[
    Booking('09:30', 'Alejandro García', 'Corte clásico', 'Diego', const Color(0xFFFFE1D7)),
    Booking('10:30', 'Marta Suárez', 'Corte + barba', 'Lucía', const Color(0xFFDDEBFF)),
    Booking('11:00', 'Pablo Martín', 'Arreglo de barba', 'Diego', const Color(0xFFE3F6E7)),
    Booking('12:30', 'Javier Torres', 'Corte premium', 'Álex', const Color(0xFFFFF0C8), status: 'Pendiente'),
    Booking('16:00', 'Sergio Gómez', 'Corte clásico', 'Lucía', const Color(0xFFEADFFF)),
  ];

  final titles = ['Agenda', 'Reservas', 'Clientes', 'Servicios', 'Equipo', 'Informes'];

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 900;
    return Scaffold(
      drawer: wide ? null : Drawer(child: _navigation()),
      body: Row(children: [
        if (wide) SizedBox(width: 250, child: _navigation()),
        Expanded(child: SafeArea(child: _content(wide))),
      ]),
      floatingActionButton: wide ? null : FloatingActionButton.extended(
        onPressed: _newBooking,
        icon: const Icon(Icons.add), label: const Text('Nueva reserva'),
      ),
    );
  }

  Widget _navigation() => Container(
        color: const Color(0xFF1D1B20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(24, 30, 20, 28),
            child: Row(children: [
              CircleAvatar(backgroundColor: Color(0xFFFF6A3D), child: Icon(Icons.content_cut, color: Colors.white)),
              SizedBox(width: 12),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('POC RESERVAS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16, letterSpacing: 1.1)),
                Text('BARBER STUDIO', style: TextStyle(color: Color(0xFFBEB7C5), fontSize: 10, letterSpacing: 1.2)),
              ])
            ]),
          ),
          for (var i = 0; i < titles.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
              child: ListTile(
                selected: section == i,
                selectedTileColor: const Color(0xFF403A43),
                selectedColor: Colors.white,
                iconColor: section == i ? const Color(0xFFFF8B67) : const Color(0xFFBEB7C5),
                textColor: section == i ? Colors.white : const Color(0xFFDED8E0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                leading: Icon([Icons.calendar_month, Icons.event_note, Icons.people_alt_outlined, Icons.design_services_outlined, Icons.groups_outlined, Icons.bar_chart_rounded][i]),
                title: Text(titles[i]),
                onTap: () { setState(() => section = i); Navigator.of(context).maybePop(); },
              ),
            ),
          const Spacer(),
          const Padding(padding: EdgeInsets.all(20), child: Row(children: [CircleAvatar(child: Text('BM')), SizedBox(width: 10), Text('Barbería Modelo', style: TextStyle(color: Colors.white))]))
        ]),
      );

  Widget _content(bool wide) => Padding(
        padding: EdgeInsets.fromLTRB(wide ? 40 : 20, 20, wide ? 40 : 20, 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            if (!wide) Builder(builder: (context) => IconButton(onPressed: () => Scaffold.of(context).openDrawer(), icon: const Icon(Icons.menu))),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(titles[section], style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
              const SizedBox(height: 3),
              const Text('Gestiona tu negocio desde un solo lugar', style: TextStyle(color: Color(0xFF6E6872))),
            ])),
            IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none)),
            const SizedBox(width: 6), const CircleAvatar(backgroundColor: Color(0xFF2E7D6C), child: Text('BM', style: TextStyle(color: Colors.white))),
          ]),
          const SizedBox(height: 26),
          if (section == 0) Expanded(child: _agenda(wide)) else Expanded(child: _placeholder()),
        ]),
      );

  Widget _agenda(bool wide) => ListView(children: [
        if (wide) Row(children: [
          Expanded(child: _metric('Reservas hoy', '12', '+3 vs. ayer', Icons.event_available, const Color(0xFFFFEEE8))),
          const SizedBox(width: 16), Expanded(child: _metric('Ocupación', '78%', 'Quedan 3 huecos', Icons.pie_chart_outline, const Color(0xFFE8F4FF))),
          const SizedBox(width: 16), Expanded(child: _metric('Ingresos previstos', '386 €', 'Ticket medio 32 €', Icons.account_balance_wallet_outlined, const Color(0xFFEAF8ED))),
        ]) else ...[_metric('Reservas hoy', '12', '+3 vs. ayer', Icons.event_available, const Color(0xFFFFEEE8)), const SizedBox(height: 10)],
        const SizedBox(height: 26),
        Row(children: [
          IconButton(onPressed: () => setState(() => selectedDay = selectedDay.subtract(const Duration(days: 1))), icon: const Icon(Icons.chevron_left)),
          Expanded(child: Center(child: Text(_dayText(selectedDay), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)))),
          IconButton(onPressed: () => setState(() => selectedDay = selectedDay.add(const Duration(days: 1))), icon: const Icon(Icons.chevron_right)),
          if (wide) const SizedBox(width: 18),
          if (wide) FilledButton.icon(onPressed: _newBooking, icon: const Icon(Icons.add), label: const Text('Nueva reserva')),
        ]),
        const SizedBox(height: 14),
        Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFE8E4E7))),
          child: Column(children: [
            const Padding(padding: EdgeInsets.fromLTRB(20, 18, 20, 10), child: Row(children: [Text('Agenda de hoy', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)), Spacer(), Text('5 de 12 reservas', style: TextStyle(color: Color(0xFF6E6872)))])),
            for (final booking in bookings) _bookingTile(booking),
            const SizedBox(height: 12),
          ]),
        ),
      ]);

  Widget _metric(String label, String value, String detail, IconData icon, Color tone) => Container(
        margin: const EdgeInsets.only(bottom: 4), padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
        child: Row(children: [CircleAvatar(radius: 24, backgroundColor: tone, child: Icon(icon, color: const Color(0xFF4A414D))), const SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(color: Color(0xFF6E6872))), const SizedBox(height: 4), Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 24)), Text(detail, style: const TextStyle(fontSize: 12, color: Color(0xFF6E6872)))]))]),
      );

  Widget _bookingTile(Booking b) => InkWell(
        onTap: () => _bookingDetails(b),
        child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11), child: Row(children: [
          SizedBox(width: 50, child: Text(b.time, style: const TextStyle(fontWeight: FontWeight.w700))),
          Container(width: 4, height: 52, decoration: BoxDecoration(color: b.color, borderRadius: BorderRadius.circular(8))), const SizedBox(width: 14),
          CircleAvatar(backgroundColor: b.color, child: Text(b.client.split(' ').map((x) => x[0]).take(2).join(), style: const TextStyle(color: Color(0xFF332E35), fontWeight: FontWeight.w700))), const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(b.client, style: const TextStyle(fontWeight: FontWeight.w700)), const SizedBox(height: 3), Text('${b.service} · ${b.barber}', style: const TextStyle(fontSize: 13, color: Color(0xFF6E6872)))])),
          Text(b.status, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: b.status == 'Confirmada' ? const Color(0xFF237A46) : const Color(0xFFAD6300))), const Icon(Icons.chevron_right, color: Color(0xFF918A93)),
        ])),
      );

  Widget _placeholder() => Center(child: Column(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.construction_rounded, size: 54, color: Color(0xFFFF6A3D)), const SizedBox(height: 14), Text('${titles[section]} en preparación', style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold)), const SizedBox(height: 6), const Text('Esta sección formará parte de la siguiente iteración de la POC.') ]));

  String _dayText(DateTime d) {
    const days = ['lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado', 'domingo'];
    const months = ['enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'];
    return '${days[d.weekday - 1][0].toUpperCase()}${days[d.weekday - 1].substring(1)}, ${d.day} de ${months[d.month - 1]}';
  }

  void _newBooking() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          24,
          24,
          24 + MediaQuery.of(sheetContext).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Nueva reserva', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
            const SizedBox(height: 20),
            const TextField(decoration: InputDecoration(labelText: 'Nombre del cliente', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            const TextField(decoration: InputDecoration(labelText: 'Servicio', hintText: 'Corte clásico', border: OutlineInputBorder())),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.of(sheetContext).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Reserva creada correctamente')),
                  );
                },
                child: const Text('Crear reserva'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _bookingDetails(Booking b) => showModalBottomSheet(context: context, builder: (context) => Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [Text(b.client, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w800)), const SizedBox(height: 8), Text('${b.time} · ${b.service} con ${b.barber}'), const SizedBox(height: 20), Row(children: [OutlinedButton(onPressed: () { Navigator.pop(context); }, child: const Text('Cerrar')), const Spacer(), FilledButton(onPressed: () { setState(() => b.status = 'Completada'); Navigator.pop(context); }, child: const Text('Marcar completada'))])])));
}
