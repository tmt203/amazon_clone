import 'dart:io';

import 'package:amazon_clone/commons/widgets/loader.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/address/services/address_service.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';

class AddressScreen extends StatefulWidget {
  static const String routeName = '/address';
  final String totalAmount;
  const AddressScreen({super.key, required this.totalAmount});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final GlobalKey<FormState> _addressFormKey = GlobalKey<FormState>();
  late SingleValueDropDownController _provinceController;
  late SingleValueDropDownController _districtController;
  late SingleValueDropDownController _wardController;
  late TextEditingController _addressController;
  final AddressService _addressService = AddressService();
  Map<String, String> province = {
    'name': '',
    'code': '',
  };
  Map<String, String> district = {
    'name': '',
    'code': '',
  };
  Map<String, String> ward = {
    'name': '',
    'code': '',
  };
  String addressToBeUsed = '';
  List<Map<String, dynamic>>? provinces;
  List<Map<String, dynamic>>? districts;
  List<Map<String, dynamic>>? wards;
  List<PaymentItem> paymentItems = [];
  bool isInformationCompleted = false;

  void fetchProvinces() async {
    provinces = await _addressService.fetchProvinces(context: context);
    setState(() {});
  }

  void fetchDistricts(String provinceCode) async {
    districts = await _addressService.fetchDistricts(context: context, provinceCode: provinceCode);
    setState(() {});
  }

  void fetchWards(String districtCode) async {
    wards = await _addressService.fetchWards(context: context, districtCode: districtCode);
    setState(() {});
  }

  void payPressed(String addressFromProvider) {
    addressToBeUsed = "";

    if (_addressController.text.isNotEmpty || ward['name']!.isNotEmpty || district['name']!.isNotEmpty || province['name']!.isNotEmpty) {
      if (_addressFormKey.currentState!.validate()) {
        addressToBeUsed = "${_addressController.text}, ${ward['name']}, ${district['name']}, ${province['name']}";
      } else {
        showSnackBar(context, 'Vui lòng điền đầy đủ thông tin!');
        throw Exception('Vui lòng điền đầy đủ thông tin!');
      }
    } else if (addressFromProvider.isNotEmpty) {
      addressToBeUsed = addressFromProvider;
    } else {
      showSnackBar(context, 'Vui lòng điền đầy đủ thông tin!');
      throw Exception('Vui lòng điền đầy đủ thông tin!');
    }
  }

  @override
  void initState() {
    _provinceController = SingleValueDropDownController();
    _districtController = SingleValueDropDownController();
    _wardController = SingleValueDropDownController();
    _addressController = TextEditingController();
    fetchProvinces();

    // payment
    paymentItems.add(PaymentItem(amount: widget.totalAmount, label: 'Tổng tiền', status: PaymentItemStatus.final_price));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _provinceController.dispose();
    _districtController.dispose();
    _wardController.dispose();
    _addressController.dispose();
  }

  void onApplePayResult(res) {
    if (Provider.of<UserProvider>(context, listen: false).user!.address!.isEmpty) {
      _addressService.saveUserAddress(context: context, address: addressToBeUsed);
    }
    _addressService.placeOrder(context: context, address: addressToBeUsed, totalPrice: double.parse(widget.totalAmount));
    _provinceController.clearDropDown();
    _districtController.clearDropDown();
    _wardController.clearDropDown();
    _addressController.clear();

    // Navigator.pop(context);
  }

  void onGooglePayResult(res) async {
    if (Provider.of<UserProvider>(context, listen: false).user!.address!.isEmpty) {
      await _addressService.saveUserAddress(context: context, address: addressToBeUsed);
    }
    await _addressService.placeOrder(context: context, address: addressToBeUsed, totalPrice: double.parse(widget.totalAmount));
    _provinceController.clearDropDown();
    _districtController.clearDropDown();
    _wardController.clearDropDown();
    _addressController.clear();

    Navigator.pop(context);
  }

  Widget payButton(String address) {
    return FutureBuilder(
      future: Platform.isIOS ? PaymentConfiguration.fromAsset("applepay.json") : PaymentConfiguration.fromAsset("gpay.json"),
      builder: (context, snapshot) => snapshot.hasData
          ? Platform.isIOS
              ? ApplePayButton(
                  onPressed: () => payPressed(address),
                  paymentConfiguration: snapshot.data!,
                  paymentItems: paymentItems,
                  style: ApplePayButtonStyle.black,
                  type: ApplePayButtonType.buy,
                  margin: const EdgeInsets.only(top: 15.0),
                  onPaymentResult: onApplePayResult,
                  loadingIndicator: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : GooglePayButton(
                  onPressed: () => payPressed(address),
                  width: double.infinity,
                  theme: GooglePayButtonTheme.light,
                  paymentConfiguration: snapshot.data!,
                  paymentItems: paymentItems,
                  type: GooglePayButtonType.buy,
                  margin: const EdgeInsets.only(top: 15.0),
                  onPaymentResult: onGooglePayResult,
                  loadingIndicator: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
          : const SizedBox.shrink(),
    );
  }

  @override
  Widget build(BuildContext context) {
    String address = context.watch<UserProvider>().user!.address!;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(gradient: GlobalVariables.appBarGradient),
          ),
        ),
      ),
      body: provinces == null
          ? const Loader()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (address.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Địa chỉ nhận hàng hiện tại:',
                            style: TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.withOpacity(0.5)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                address,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: const Text('----- / hoặc / -----'),
                          ),
                        ],
                      ),
                    const Text(
                      'Cập nhật thông tin địa chỉ:',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Form(
                      key: _addressFormKey,
                      child: Column(
                        children: [
                          DropDownTextField(
                            controller: _provinceController,
                            enableSearch: true,
                            textFieldDecoration: const InputDecoration(
                              hintText: 'Tỉnh/Thành phố',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black38, width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black38, width: 1.0),
                              ),
                            ),
                            searchDecoration: const InputDecoration(
                              hintText: 'Tìm kiếm...',
                            ),
                            dropdownColor: Colors.white,
                            dropDownList: provinces!.map((e) => DropDownValueModel(name: e['province_name'], value: e['province_id'])).toList(),
                            onChanged: (value) {
                              if (value.runtimeType == DropDownValueModel) {
                                province['name'] = value.name;
                                province['code'] = value.value;
                                fetchDistricts(province['code']!);
                              } else {
                                province['name'] = '';
                                province['code'] = '';
                                _districtController.clearDropDown();
                                _wardController.clearDropDown();
                                _addressController.clear();
                                district['name'] = '';
                                district['code'] = '';
                                ward['name'] = '';
                                ward['code'] = '';
                              }
                              setState(() {});
                            },
                          ),
                          const SizedBox(height: 10),
                          DropDownTextField(
                            controller: _districtController,
                            enableSearch: true,
                            textFieldDecoration: const InputDecoration(
                              hintText: 'Quận/Huyện/Thị xã',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black38, width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black38, width: 1.0),
                              ),
                            ),
                            searchDecoration: const InputDecoration(
                              hintText: 'Tìm kiếm...',
                            ),
                            dropdownColor: Colors.white,
                            isEnabled: province['name']!.isEmpty ? false : true,
                            dropDownList: (districts != null
                                ? districts!.map((e) => DropDownValueModel(name: e['district_name'], value: e['district_id'])).toList()
                                : []),
                            onChanged: (value) {
                              if (value.runtimeType == DropDownValueModel) {
                                district['name'] = value.name;
                                district['code'] = value.value;
                                fetchWards(district['code']!);
                              } else {
                                district['name'] = '';
                                district['code'] = '';
                                _wardController.clearDropDown();
                                ward['name'] = '';
                                ward['code'] = '';
                              }
                              setState(() {});
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng không để trống mục này';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          DropDownTextField(
                            controller: _wardController,
                            enableSearch: true,
                            textFieldDecoration: const InputDecoration(
                              hintText: 'Phường/Xã/Thị trấn',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black38, width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black38, width: 1.0),
                              ),
                            ),
                            searchDecoration: const InputDecoration(
                              hintText: 'Tìm kiếm...',
                            ),
                            dropdownColor: Colors.white,
                            isEnabled: district['name']!.isEmpty ? false : true,
                            dropDownList:
                                (wards != null ? wards!.map((e) => DropDownValueModel(name: e['ward_name'], value: e['ward_id'])).toList() : []),
                            onChanged: (value) {
                              if (value.runtimeType == DropDownValueModel) {
                                ward['name'] = value.name;
                                ward['code'] = value.value;
                              } else {
                                ward['name'] = '';
                                ward['code'] = '';
                                _addressController.clear();
                              }
                              setState(() {});
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng không để trống mục này';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _addressController,
                            keyboardType: TextInputType.name,
                            enabled: ward['name']!.isEmpty ? false : true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black38),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black38),
                              ),
                              hintText: 'Số nhà, tên đường (VD: 61/15, Thạch Lam)',
                            ),
                            onChanged: (value) => setState(() {}),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng không để trống mục này';
                              }
                              return null;
                            },
                          ),
                          payButton(address),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
