import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VerificationScreen extends ConsumerWidget {
  static const routePath = '/payments/verification';
  static const routeName = 'payments-verification';

  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifikasi Pembayaran'),
      ),
      body: Column(
        children: const [
          SizedBox(height: 20),
          Text('Kode Verifikasi'),
          SizedBox(height: 10),
          Text('Kode verifikasi telah dikirim ke nomor telepon Anda'),
          SizedBox(height: 20),
          Text('Masukkan kode verifikasi'),
          SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Kode Verifikasi',
            ),
          ),
          SizedBox(height: 20),
          Text('Kirim ulang kode verifikasi'),
          SizedBox(height: 10),
          Text('Kirim ulang kode verifikasi dalam 00:30'),
          SizedBox(height: 20),
          Text('Lanjut'),
          SizedBox(height: 10),
          Text('Lanjutkan untuk menyelesaikan pembayaran'),
          SizedBox(height: 20),
          Text('Batal'),
          SizedBox(height: 10),
          Text('Batalkan pembayaran'),
        ],
      ),
    );
  }
}
