import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenify/ui/layout/app_bar.dart';
import 'package:greenify/ui/layout/drawer.dart';
import 'package:greenify/ui/layout/header.dart';

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const NewAppbar(title: "Tentang Kami"),
      endDrawer: const GrDrawerr(),
      body: Material(
        color: Theme.of(context).colorScheme.background,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Header(text: 'Greeny'),
                  const SizedBox(height: 36),
                  Image.network(
                    "https://firebasestorage.googleapis.com/v0/b/greenify-f07ad.appspot.com/o/uploads%2Fgreeny%20png.png?alt=media&token=57178ec2-6cb3-4322-b89d-e3c0863193b4",
                    height: 300,
                  ),
                  const SizedBox(height: 36),
                  const Text(
                    'Greeny adalah aplikasi mobile berbasis platform Android yang inovatif, didedikasikan untuk memudahkan dan menyenangkan pengalaman berkebun di lingkungan perkotaan. Dengan mengintegrasikan konsep gamifikasi dan edukasi lingkungan, Greeny menciptakan pengalaman berkebun yang interaktif dan menginspirasi Anda untuk menjadi lebih sadar akan pentingnya pertanian perkotaan dan kelestarian lingkungan.',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Visi kami adalah menciptakan kota-kota yang lebih hijau dan berkelanjutan, di mana setiap orang dapat terlibat dalam kegiatan pertanian perkotaan. Melalui Greeny, kami berkomitmen untuk menyebarkan kesadaran tentang pentingnya berkebun di kota, mempromosikan gaya hidup yang lebih ramah lingkungan, dan mengajak orang untuk berkontribusi dalam menjaga keanekaragaman hayati.',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Melalui Greeny, Anda akan memperoleh pengetahuan yang mendalam tentang penanaman dan perawatan tanaman di perkotaan. Greeny memberikan informasi tentang berbagai jenis tanaman yang cocok ditanam di lingkungan perkotaan, tips perawatan, serta pengelolaan air dan nutrisi yang efisien. Greeny juga dapat mendeteksi penyakit pada tanaman dengan menggunakan konsep machine learning. Selain itu, Greeny menerapkan konsep gamification, yaitu penggunaan elemen-elemen permainan seperti penghargaan, pencapaian, dan kompetisi berupa sistem ranking untuk memotivasi Anda dalam menjaga dan merawat tanaman mereka.',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Dengan Greeny, Anda dapat menikmati berkebun tanpa batas ruang dan waktu. Bersiaplah untuk mengasah kemampuan berkebun Anda, mendapatkan wawasan baru tentang pertanian perkotaan, dan merasakan kebahagiaan melihat tanaman Anda tumbuh dan berkembang. Greeny memudahkan Anda untuk terhubung dengan alam dan menjadi agen perubahan untuk masa depan yang lebih berkelanjutan. Mulailah petualangan berkebun Anda sekarang dengan Greeny, aplikasi yang membawa alam lebih dekat ke dalam kehidupan Anda.',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
