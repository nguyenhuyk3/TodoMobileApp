// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:logger/logger.dart';

import 'colors.dart';
import 'tables.dart';

const MINIMUM_LENGTH_FOR_PASSWORD = 8;
const LENGTH_OF_OTP = 6;
const TIME_FOR_RESENDING_MAIL = 10;

final COLORS = AppColors();
final TABLES = Tables();

final LOGGER = Logger();
