import 'package:flutter/material.dart';
import 'package:hospital_management_system/repository/category_repository.dart';
import 'package:hospital_management_system/response/doctor_appointment/get_doctor_appointment_response.dart';
import 'package:hospital_management_system/response/doctor_ui_appointment/get_doctor_ui_appointment.dart';
import 'package:hospital_management_system/screens/bottom_nav_bar.dart';
import 'package:hospital_management_system/screens/bottom_nav_doctor.dart';
import 'package:hospital_management_system/utils/show_message.dart';
import 'package:hospital_management_system/utils/url.dart';

class DoctorPendingPage extends StatefulWidget {
  const DoctorPendingPage({Key? key}) : super(key: key);

  @override
  State<DoctorPendingPage> createState() => _DoctorPendingPageState();
}

class _DoctorPendingPageState extends State<DoctorPendingPage> {
    Map<String, dynamic> allDrinks = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 255),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Bidding Schedule",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Color.fromARGB(255, 36, 58, 96),
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                FutureBuilder<List<GetDoctorUIAppointment?>>(
                  future:
                      CategoryRepository().getDoctorUIAppointment("Bidding"),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      

                      if (snapshot.data!.isNotEmpty) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height / 1.3,
                          child: ListView.separated(
                            itemCount: snapshot.data!.length,
                            separatorBuilder: (BuildContext context, index) {
                              return const SizedBox(height: 20);
                            },
                            itemBuilder: (BuildContext context, index) {
                              debugPrint(
                          "data Apt doctor: " + snapshot.data![index]!.price.toString());
                              return scheduleContainer(snapshot.data![index], index);
                            },
                          ),
                        );
                      } else {
                        return const Center(
                          child: Text("No Pending Schedule"),
                        );
                      }
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text("Error"),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget scheduleContainer(
      GetDoctorUIAppointment? appointmentResponse, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        // height: height * 0.13,
        width: double.infinity,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 235, 235, 235).withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.circular(20),
          // color: const Color.fromRGBO(11, 86, 222, 5),
          color: Colors.white,
        ),
        child: Row(
          children: [
            SizedBox(
              height: 80,
              width: 80,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image(
                  image: appointmentResponse!.patientId!.picture == null
                      ? const NetworkImage(
                          "https://w.wallhaven.cc/full/x8/wallhaven-x8gkvz.jpg")
                      : NetworkImage(
                          baseUrl + appointmentResponse.patientId!.picture!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // SizedBox(
            //   width: 0.0468 * width,
            // ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appointmentResponse.patientId!.username!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            appointmentResponse.price!,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                          ),
                          Text(
                            "Name: " + appointmentResponse.fullname!,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            appointmentResponse.status!,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: appointmentResponse.status! == "Bidding"
                                  ? Colors.amber
                                  : appointmentResponse.status! == "Accepted"
                                      ? Colors.green
                                      : Colors.red,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      Column(
                        children: [
                          SizedBox(
                            height: 40,
                            width: 100,
                            child: TextFormField(
                              // initialValue: "0",
                              onChanged: (value) {
                                if (allDrinks.containsKey(index.toString()) &&
                                    int.parse(allDrinks[index.toString()]) >=
                                        0) {
                                  debugPrint("No. 1");
                                  setState(() {
                                    allDrinks[index.toString()] = value;
                                  });
                                } else {
                                  debugPrint("No. 3");

                                  final whiskey = <String, dynamic>{
                                    index.toString(): value
                                  };
                                  allDrinks.addEntries(whiskey.entries);
                                  debugPrint("JDJDJDJDJ");
                                }
                                debugPrint("Whiskey QTY:   $allDrinks");

                                // else if(whiskeyQty.containsKey(index) && value.isEmpty){}
                              },
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: "Bid",
                                filled: true,
                                fillColor:
                                    const Color.fromARGB(255, 241, 241, 241),
                                border: const UnderlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color.fromARGB(0, 249, 192, 192)),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (appointmentResponse.status! == "Bidding")
                                InkWell(
                                  onTap: () {
                                    GetDoctorAppointmentResponse
                                        getDoctorAppointmentResponse =
                                        GetDoctorAppointmentResponse(
                                            id: appointmentResponse.id,
                                            price: allDrinks[index.toString()],
                                            );
                                    _updateDoctorAppointment(
                                        getDoctorAppointmentResponse);
                                  },
                                  child: SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: CircleAvatar(
                                      // backgroundColor: Colors.white,
                                      backgroundColor: Colors.grey[100],

                                      child: const Center(
                                        child: Icon(
                                            Icons.send_and_archive_sharp,
                                            size: 22),
                                      ),
                                    ),
                                  ),
                                ),
                              if (appointmentResponse.status! != "Ended")
                                InkWell(
                                  onTap: () {
                                    deleteAppointment(appointmentResponse);
                                  },
                                  child: SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: CircleAvatar(
                                      // backgroundColor: Colors.white,
                                      backgroundColor: Colors.grey[100],
                                      child: const Center(
                                        child: Icon(
                                          Icons.delete,
                                          size: 22,
                                          color:
                                              Color.fromARGB(255, 227, 51, 39),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.lock_clock,
                        color: appointmentResponse.status! == "Bidding"
                            ? Colors.amber
                            : appointmentResponse.status! == "Accepted"
                                ? const Color.fromRGBO(11, 86, 222, 5)
                                // ? Colors.green
                                : Colors.red,
                        size: 18,
                      ),
                      Text(
                        appointmentResponse.status! == "Bidding"
                            ? appointmentResponse.time!
                            : appointmentResponse.date! +
                                " - " +
                                appointmentResponse.time!,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: appointmentResponse.status! == "Bidding"
                              ? Colors.amber
                              : appointmentResponse.status! == "Accepted"
                                  ? const Color.fromRGBO(11, 86, 222, 5)
                                  // ? Colors.green
                                  : Colors.red,
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      if (appointmentResponse.status! == "Bidding")
                        SizedBox(
                          width: 100,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color.fromRGBO(38, 0, 185, 1)),
                              elevation: MaterialStateProperty.all(0),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                              ),
                            ),
                            onPressed: () async {
                              _updateDoctorAppointmentStatus(appointmentResponse.id!, "Accepted");
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const BottomNavDoctor(index: 2),
                                ),
                              );
                              //  final String encodedList = draftList.toString();

                              //  await prefs.setString('draft_data', encodedList);

                              //  debugPrint("EncodedList: $encodedList");
                              //  debugPrint("EncodedList: $encodedList");
                              //  final List<dynamic> decodedList = jsonDecode(encodedList);
                            },
                            child: const Text("Accept"),
                          ),
                        ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

   _updateDoctorAppointment(
      GetDoctorAppointmentResponse bookdoctorAppointment) async {
    bool isUpdated = await CategoryRepository()
        .updateDoctorAppointment(bookdoctorAppointment, "Bidding");
    _displayMessage(isUpdated);
  }

  _updateDoctorAppointmentStatus(
      String id, String status) async {
    bool isUpdated = await CategoryRepository()
        .updateDoctorUIAppointment(id, status);
    
  }

  _displayMessage(bool isSignUp) {
    if (isSignUp) {
      displaySuccessMessage(context, "Price changed");
      Future.delayed(const Duration(milliseconds: 1500), () {
        // Navigator.pushNamed(context, '/bottomNavBar');
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const BottomNavDoctor(index: 0)),
        );
      });
    } else {
      displayErrorMessage(context, "Failed to book Appointment");
    }
  }

  acceptAppointment(GetDoctorUIAppointment appointmentResponse) async {
    debugPrint("Appointment ID: " + appointmentResponse.id!);
    bool isAccepted = await CategoryRepository()
        .updateDoctorUIAppointment(appointmentResponse.id!, "Accepted");
    if (isAccepted) {
      displaySuccessMessage(context, "Appointment Accepted");
      Future.delayed(
        const Duration(milliseconds: 1500),
        () {
          // Navigator.pushNamed(context, '/bottomNavBar');
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => const BottomNavDoctor(index: 1)),
          );
        },
      );
    } else {
      displayErrorMessage(context, "Appointment Couldnot be Accepted");
    }
  }

  deleteAppointment(GetDoctorUIAppointment appointmentResponse) async {
    bool isDeleted;
    isDeleted = await CategoryRepository()
        .deleteDoctorAppointment(appointmentResponse.id!);
    if (isDeleted == true) {
      // debugPrint(isDeleted.toString());
      displaySuccessMessage(context, "Appointment deleted successfully");
      Future.delayed(
        const Duration(milliseconds: 1500),
        () {
          // Navigator.pushNamed(context, '/bottomNavBar');
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => const BottomNavBar(index: 2)),
          );
        },
      );
    }
  }
}
