import 'package:flutter/material.dart';
import 'package:manazco/theme/colors.dart';
import 'package:manazco/theme/text_style.dart';
import 'package:manazco/theme/theme.dart';

class AcercaDeScreen extends StatelessWidget {
  const AcercaDeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Acerca de"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildCompanyHeader(),
              const SizedBox(height: 24),
              _buildAboutSection(),
              const SizedBox(height: 24),
              _buildValuesSection(),
              const SizedBox(height: 24),
              _buildContactSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompanyHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Image.asset(
                'assets/images/sodep_logo.png',
                width: 100,
                height: 100,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "SODEP S.A.",
            style: AppTextStyles.headingxl.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Soluciones de Desarrollo Profesional",
            style: AppTextStyles.bodyLg.copyWith(color: AppColors.gray14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Container(
      decoration: AppTheme.sectionBorderGray05,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                "Sobre la Empresa",
                style: AppTextStyles.bodyLgSemiBold.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "SODEP S.A. es una empresa comprometida con la excelencia y el desarrollo profesional, brindando soluciones innovadoras y servicios de calidad a nuestros clientes.",
            style: AppTextStyles.bodyLg.copyWith(color: AppColors.gray14),
          ),
        ],
      ),
    );
  }

  Widget _buildValueCard({
    required IconData icon,
    required String title,
    required String description,
    required Color backgroundColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyLgSemiBold.copyWith(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTextStyles.bodyLg.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValuesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.favorite, color: AppColors.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              "Valores Sodepianos",
              style: AppTextStyles.bodyLgSemiBold.copyWith(
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildValueCard(
          icon: Icons.verified_user,
          title: "Honestidad",
          description:
              "Actuamos con transparencia y verdad en todas nuestras relaciones",
          backgroundColor: AppColors.primary,
        ),
        _buildValueCard(
          icon: Icons.star,
          title: "Calidad",
          description:
              "Nos esforzamos por la excelencia en cada proyecto y servicio",
          backgroundColor: AppColors.primary.withOpacity(0.9),
        ),
        _buildValueCard(
          icon: Icons.sync,
          title: "Flexibilidad",
          description: "Nos adaptamos a las necesidades cambiantes del mercado",
          backgroundColor: Colors.grey[600]!,
        ),
        _buildValueCard(
          icon: Icons.chat,
          title: "Comunicación",
          description:
              "Mantenemos diálogo abierto y efectivo con todos nuestros stakeholders",
          backgroundColor: AppColors.primary.withOpacity(0.9),
        ),
        _buildValueCard(
          icon: Icons.self_improvement,
          title: "Autogestión",
          description:
              "Fomentamos la responsabilidad personal y la iniciativa propia",
          backgroundColor: AppColors.primary.withOpacity(0.8),
        ),
      ],
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.gray13, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodyLgSemiBold),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: AppTextStyles.bodyLg.copyWith(color: AppColors.gray02),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return Container(
      decoration: AppTheme.sectionBorderGray05,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.contact_phone, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                "Información de Contacto",
                style: AppTextStyles.bodyLgSemiBold.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildContactItem(
            icon: Icons.location_on,
            title: "Dirección",
            content: "Bélgica 839 c/ Eusebio Lillo\nAsunción, Paraguay",
          ),
          _buildContactItem(
            icon: Icons.phone,
            title: "Teléfono",
            content: "(+595) 981-131-694",
          ),
          _buildContactItem(
            icon: Icons.email,
            title: "Email",
            content: "info@sodep.com.py",
          ),
          _buildContactItem(
            icon: Icons.web,
            title: "Sitio Web",
            content: "www.sodep.com.py",
          ),
        ],
      ),
    );
  }
}
