import 'package:intl/intl.dart';

class Formatters {
  // Formatar moeda brasileira
  static String formatMoney(double value) {
    final formatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
      decimalDigits: 2,
    );
    return formatter.format(value);
  }
  
  // Formatar data
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }
  
  // Formatar data e hora
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }
  
  // Formatar hora
  static String formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }
  
  // Formatar telefone
  static String formatPhone(String phone) {
    final numbersOnly = phone.replaceAll(RegExp(r'[^\d]'), '');
    
    if (numbersOnly.length == 11) {
      return '(${numbersOnly.substring(0, 2)}) ${numbersOnly.substring(2, 7)}-${numbersOnly.substring(7)}';
    } else if (numbersOnly.length == 10) {
      return '(${numbersOnly.substring(0, 2)}) ${numbersOnly.substring(2, 6)}-${numbersOnly.substring(6)}';
    }
    
    return phone;
  }
  
  // Formatar CEP
  static String formatCEP(String cep) {
    final numbersOnly = cep.replaceAll(RegExp(r'[^\d]'), '');
    
    if (numbersOnly.length == 8) {
      return '${numbersOnly.substring(0, 5)}-${numbersOnly.substring(5)}';
    }
    
    return cep;
  }
  
  // Formatar distância
  static String formatDistance(double distanceKm) {
    if (distanceKm < 1) {
      return '${(distanceKm * 1000).toStringAsFixed(0)}m';
    }
    return '${distanceKm.toStringAsFixed(1)}km';
  }
  
  // Formatar rating
  static String formatRating(double rating) {
    return rating.toStringAsFixed(1);
  }
  
  // Nome para iniciais
  static String getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }
}
