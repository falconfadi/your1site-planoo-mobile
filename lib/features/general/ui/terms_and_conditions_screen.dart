import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/classes/app_storage.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_header.dart';
import 'package:centro_partner/core/utils/project_utils/open_url.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TermsAndConditionsScreen extends StatelessWidget {

  const TermsAndConditionsScreen({super.key});

  final String termsArabic = """

<div dir="rtl" style="text-align:right;">

<h1>(الشروط والأحكام) PLANOO - بلانوو</h1>

<p style="margin-bottom:18px;"><strong>تاريخ آخر تحديث:</strong> [04/27/2026]</p>

<p>
بدخولك أو استخدامك لتطبيق أو موقع PLANOO(بلانوو) اﻹلكتروني (يُشار إليهما معًا بـ "المنصة")، فإنك تقرّ بموافقتك الكاملة و الملزمة على هذه الشروط والأحكام.
في حال عدم موافقتك، يُرجى عدم استخدام المنصة.
</p>

<h2>1. نبذة عن PLANOO</h2>
<p style="margin:0;">
PLANOO هي <strong>منصة رقمية تعمل كوسيط تقني </strong> يهدف إلى تسهيل اكتشاف وحجز وإدارة الخدمات المقدّمة من قبل أطراف ثالثة مستقلة (ويُشار إليهم ب "العملاء").
</p>
<p style="margin:0;">
PLANOO <strong> ﻻ تقوم بتقديم أي خدمات بنفسها</strong>، وﻻ تشرف أو تتحكم بشكل مباشر في أنشطة العملاء.
</p>

<hr style="border-top:1px solid #ddd; margin:12px 0;">

<h2>2. أهلية اﻻستخدام</h2>
<ul>
  <li>يجب أن يكون المستخدم مؤهلا ً قانونيًا ﻹبرام العقود وفقًا للقوانين المعمول بها.</li>
  <li>يُسمح للقاصرين باستخدام المنصة فقط تحت مسؤولية وإشراف الوالدين أو الولي القانوني.</li>
</ul>

<hr style="border-top:1px solid #ddd; margin:12px 0;">

<h2>3. دور PLANOO</h2>
<ul>
  <li>تعمل PLANOO حصريًا <strong>كمنصة تقنية ووسيط للحجوزات</strong>.</li>
  <li><strong>ﻻ تُعد</strong> PLANOO <strong>طرفاً</strong> في أي اتفاق أو علاقة تعاقدية بين المستخدمين و العملاء.</li>
  <li>يتم تقديم أي خدمة <strong>بشكل مباشر من قبل العميل, </strong>وعلى مسؤوليته الكاملة.</li>
</ul>

<hr style="border-top:1px solid #ddd; margin:12px 0;">

<h2>4.  مسؤوليات العملاء</h2>
<p>يتحمل العملاء المسؤولية الكاملة عن:</p>
<ul>
  <li>صحة ودقة المعلومات المعروضة (اﻷسعار، الجداول، الخدمات، التوافر).</li>
  <li>جودة وسلامة وقانونية الخدمات المقدّمة.</li>
  <li>اﻻلتزام بكافة القوانين والتراخيص والتصاريح المعمول بها.</li>
  <li>أي إصابة، ضرر، خسارة، سوء سلوك، أو تصرف إجرامي يحدث داخل منشآتهم أو أثناء تقديم خدماتهم.</li>
</ul>
<p><strong>لا</strong> تتحمل PLANOO <strong>أي مسؤولية</strong> عن أفعال أو إهمال العملاء.</p>

<hr style="border-top:1px solid #ddd; margin:12px 0;">

<h2>5. مسؤوليات المستخدمين</h2>
<p>يوافق المستخدم على:</p>
<ul>
  <li>استخدام المنصة بطريقة قانونية ومحترمة.</li>
  <li> الالتزام بمواعيد الحجز والتعليمات الخاصة بالعميل وتحمل رسوم إلغاء أو التأخير.</li>
  <li>تحمّل المسؤولية الكاملة عن سلوكه أو تصرفاته.</li>
  <li>الإقرار بأن المشاركة في أي نشاط تتم على <strong>مسؤوليته الشخصية</strong>.</li>
</ul>

<hr style="border-top:1px solid #ddd; margin:12px 0;">

<h2>6. اﻷعمال اﻹجرامية والسلوك غير القانوني</h2>
<p><strong>تُخلي</strong> PLANOO <strong> مسؤوليتها بشكل صريح</strong> عن أي أعمال إجرامية أو غير قانونية، بما في ذلك على سبيل المثال ﻻ الحصر:</p>
<ul>
  <li>اﻻعتداء، التحرش، اﻹساءة، أو العنف بجميع أشكاله.</li>
  <li>السرقة، اﻻحتيال، أو إتلاف الممتلكات.</li>
  <li>أي سلوك جنسي غير ﻻئق أو مخالف للقانون.</li>
  <li>تعاطي أو ترويج المخدرات أو الكحول أو حيازة اﻷسلحة.</li>
  <li>أي تصرف يخالف القوانين المحلية أو الدولية.</li>
</ul>
<p><strong>تقع المسؤولية الكاملة عن هذه اﻷفعال على اﻷطراف المتورطة أو العملاء, </strong>ويجب اﻹبلاغ عنها مباشرة إلى الجهات المختصة.</p>

<hr style="border-top:1px solid #ddd; margin:12px 0;">

<h2>7. اﻹصابات والحوادث والحالة الصحية</h2>
<ul>
  <li>يقر المستخدم بأن بعض اﻷنشطة قد تنطوي على مخاطر جسدية.</li>
  <li><strong>لا تتحمل</strong> PLANOO <strong> أي مسؤولية </strong>عن اﻹصابات، الحوادث، المشكلات الصحية، أو الوفاة.</li>
  <li>يتحمل المستخدم مسؤولية تقييم حالته الصحية وقدرته على المشاركة.</li>
  <li>يتحمل العميل مسؤولية إجراءات السلامة داخل منشآته.</li>
</ul>

<hr style="border-top:1px solid #ddd; margin:12px 0;">

<h2>8. المدفوعات والمسؤولية المالية</h2>
<ul>
  <li>قد تقوم PLANOO بتسهيل عمليات الدفع دون ضمان تنفيذ الخدمة.</li>
  <li>تخضع سياسات اﻹلغاء واﻻسترداد لشروط العميل.</li>
  <li>ﻻ تتحمل PLANOO أي مسؤولية عن النزاعات المالية بين المستخدمين و العملاء.</li>
</ul>

<h2>9. الجلسة الأولى المجانية والعروض الترويجية</h2>
<ul>
  <li>تُحدّد أي جلسة مجانية أو عرض ترويجي من قبل العميل وحده.</li>
  <li>ﻻ تضمن PLANOO  توفر العروض أو مدتها أو نتائجها.</li>
</ul>

<hr style="border-top:1px solid #ddd; margin:12px 0;">

<h2>10. تعليق أو إنهاء الحسابات</h2>
<p>تحتفظ PLANOO بالحق في:</p>
<ul>
  <li>تعليق أو إنهاء أي حساب في حال مخالفة الشروط.</li>
  <li>إزالة أي مستجدم أو عميل وفقًا لتقديرها الخاص.</li>
  <li>تعديل أو إيقاف المنصة أو أي جزء منها دون تحمّل أي مسؤولية.</li>
</ul>

<hr style="border-top:1px solid #ddd; margin:12px 0;">

<h2>11. تحديد المسؤولية</h2>
<p>إلى أقصى حد يسمح به القانون:</p>
<ul>
  <li>ﻻ تتحمل PLANOO أي مسؤولية عن اﻷضرار المباشرة أو غير المباشرة أو التبعية.</li>
  <li>ﻻ تتحمل PLANOO أي مسؤولية عن فقدان اﻷرباح أو البيانات أو السمعة أو اﻷذى الشخصي.</li>
  <li>في جميع اﻷحوال، ﻻ تتجاوز مسؤولية PLANOO (إن وُجدت) المبالغ المدفوعة لها مباشرة.</li>
</ul>

<hr style="border-top:1px solid #ddd; margin:12px 0;">

<h2>12. التعويض</h2>
<p>يوافق المستخدمين و العملاء على <strong> تعويض وإبراء ذمة PLANOO</strong> ومؤسسيها وفريقها من أي مطالبات أو أضرار أو خسائر أو دعاوى قانونية ناتجة عن:</p>
<ul>
  <li>استخدامهم للمنصة.</li>
  <li>تعاملاتهم مع أطراف أخرى.</li>
  <li>مخالفتهم لهذه الشروط.</li>
</ul>

<h2>13. الخصوصية والبيانات</h2>
<p style="margin:0;">تتم معالجة البيانات الشخصية وفقًا <strong>لسياسة الخصوصية </strong>الخاصة بالمنصة.</p>
<p style="margin:0;">ولا يتم الإفصاح عن البيانات إلا إذا طُلب ذلك بموجب القانون.</p>

<hr style="border-top:1px solid #ddd; margin:12px 0;">

<h2>14. القانون الواجب التطبيق وحل النزاعات</h2>
<ul>
  <li>تخضع هذه الشروط للقوانين المعمول بها محليًا.</li>
  <li>تُحل النزاعات وديًا أوﻻً, وفي حال تعذر ذلك تُحال إلى الجهات القضائية في محاكم دمشق بعد إعلام الفريق القانوني للشركة على عنوان الشركة.</li>
</ul>

<hr style="border-top:1px solid #ddd; margin:12px 0;">

<h2>15. تعديل الشروط</h2>
<p>
تحتفظ PLANOO بحق تعديل هذه الشروط في أي وقت، ويُعد استمرار استخدام المنصلة موافقة ضمنية على التعديلات.
</p>

<hr style="border-top:1px solid #ddd; margin:12px 0;">

<h2 style="margin:5px;">16. التواصل</h2>

</div>

""";


  final String termsEnglish = """

<h1>PLANOO – Terms & Conditions</h1>

<p style="margin-bottom:18px;"><strong>Last Updated:</strong> [04/27/2026]</p>

<p>By accessing or using the PLANOO mobile application or website (the “Pla orm”), you agree to 
be bound by these Terms & Conditions. If you do not agree, please do not use the Platform.</p>

<h2>1. About PLANOO</h2>
<p style="margin:0;">PLANOO is a <strong>digital platform and intermediary</strong> that facilitates the discovery, booking, and 
management of services offered by independent third-party partners (“Partners”).</p>
<p style="margin:0;">PLANOO <strong>does not provide the services itself</strong> and does not control or supervise Partner 
activities.</p>

<hr style="border: 0.5px solid black; border-top:1px solid #ddd; margin:12px 0;">

<h2>2. User Eligibility</h2>
<ul>
  <li>Users must be legally capable of entering binding agreements under applicable law.</li>
  <li>Minors may only use the Platform under parental or legal guardian responsibility.</li>
</ul>

<hr style="border: 0.5px solid black; border-top:1px solid #ddd; margin:12px 0;">

<h2>3. Role of PLANOO (Important Disclaimer) </h2>
<ul>
  <li>PLANOO acts <strong>solely as a technology provider and booking facilitator.</strong></li>
  <li>PLANOO is <strong>NOT a party</strong> to any agreement between Users and Partners.</li>
  <li>Any service is provided <strong>directly by the Partner,</strong> at their own responsibility.</li>
</ul>

<hr style="border: 0.5px solid black; border-top:1px solid #ddd; margin:12px 0;">

<h2>4. Partner Responsibility </h2>
<p>Partners are solely responsible for: </p>
<ul>
  <li>The accuracy of their information, schedules, prices, and availability.</li>
  <li>The quality, safety, legality, and delivery of their services.</li>
  <li>Compliance with all applicable laws, licenses, permits, and regulations.</li>
  <li>Any injury, damage, loss, misconduct, or criminal behavior occurring at their facilities or 
  during their services. </li>
</ul>
<p>PLANOO bears <strong>no liability</strong> for Partner actions or omissions.</p>

<hr style="border: 0.5px solid black; border-top:1px solid #ddd; margin:12px 0;">

<h2>5. User Responsibility </h2>
<p>Users agree to: </p>
<ul>
  <li>Use the Platform lawfully and respectfully.</li>
  <li>Arrive on me for bookings and follow Partner rules.</li>
  <li>Take full responsibility for their own behavior and actions.</li>
  <li>Accept that participation in any activity is <strong>at their own risk.</strong></li>
</ul>

<hr style="border: 0.5px solid black; border-top:1px solid #ddd; margin:12px 0;">

<h2>6. Criminal Acts & Illegal Behavior</h2>
<p>PLANOO <strong>explicitly disclaims all responsibility</strong> for any criminal, illegal, or harmful acts including 
but not limited to: </p>
<ul>
  <li>Assault, harassment, abuse, or violence.</li>
  <li>Theft, fraud, or property damage.</li>
  <li>Sexual misconduct or inappropriate behavior.</li>
  <li>Drug, alcohol, or weapon-related incidents.</li>
  <li>Any action violating local or international law.</li>
</ul>
<p>Any such acts are <strong>solely the responsibility of the involved individuals or Partners,</strong> and must be 
reported directly to the competent authorities.</p>

<hr style="border: 0.5px solid black; border-top:1px solid #ddd; margin:12px 0;">

<h2>7. Injuries, Accidents & Health</h2>
<ul>
  <li>Users acknowledge that some activities may involve physical risk.</li>
  <li>PLANOO is <strong>not responsible</strong> for injuries, accidents, health issues, or death.</li>
  <li>Users are responsible for assessing their own health and fitness.</li>
  <li>Partners are responsible for safety measures within their facilities.</li>
</ul>

<hr style="border: 0.5px solid black; border-top:1px solid #ddd; margin:12px 0;">

<h2>8. Payments & Financial Liability</h2>
<ul>
  <li>PLANOO may facilitate payments but does not guarantee service <strong>fulfillment.</strong></li>
  <li>Refunds, cancellations, or disputes are governed by Partner policies.</li>
  <li>PLANOO is not liable for payment disputes between Users and Partners.</li>
</ul>

<h2>9. First Free Session / Promotions</h2>
<ul>
  <li>Any free trial or promotional offer is determined by Partners.</li>
  <li>PLANOO does not guarantee availability, duration, or outcomes of promotions.</li>
</ul>

<hr style="border: 0.5px solid black; border-top:1px solid #ddd; margin:12px 0;">

<h2>10. Account Suspension & Termination</h2>
<p>PLANOO reserves the right to: </p>
<ul>
 <li>Suspend or terminate accounts for violations of these Terms.</li>
 <li>Remove any Partner or User at its sole discretion.</li>
 <li>Modify or discontinue the Platform without liability.</li>
</ul>

<hr style="border: 0.5px solid black; border-top:1px solid #ddd; margin:12px 0;">

<h2>11. Limitation of Liability</h2>
<p>To the maximum extent permitted by law: </p>
<ul>
 <li>PLANOO shall not be liable for any direct, indirect, incidental, or consequential damages.</li>
 <li>PLANOO is not responsible for loss of profit, data, reputation, or personal harm.</li>
 <li>Total liability, if any, shall not exceed the amount paid to PLANOO (if applicable).</li>
</ul>

<hr style="border: 0.5px solid black; border-top:1px solid #ddd; margin:12px 0;">

<h2>12. Indemnification</h2>
<p>Users and Partners agree to <strong>indemnify and hold harmless PLANOO,</strong> its founders, team, and 
affiliates from any claims, damages, losses, or legal actions arising from: </p>
<ul>
 <li>Their use of the Platform.</li>
 <li>Their interactions with other parties.</li>
 <li>Any breach of these Terms.</li>
</ul>

<h2>13. Privacy & Data</h2>
<p style="margin:0;">User data is handled in accordance with the <strong>Privacy Policy.</strong></p>
<p style="margin:0;">PLANOO does not share personal data except as required by law.</p>

<hr style="border: 0.5px solid black; border-top:1px solid #ddd; margin:12px 0;">

<h2>14.Governing Law & Dispute Resolution</h2>
<ul>
 <li>These Terms are governed by applicable local laws.</li>
 <li>Any dispute shall first be attempted to be resolved amicably.</li>
 <li>If unresolved, disputes shall be referred to competent courts or arbitration as applicable.</li>
</ul>

<hr style="border: 0.5px solid black; border-top:1px solid #ddd; margin:12px 0;">

<h2>15. Changes to Terms</h2>
<p>PLANOO may update these Terms at any me. Continued use of the Platform constitutes acceptance of the updated Terms.</p>

<hr style="border: 0.5px solid black; border-top:1px solid #ddd; margin:12px 0;">

<h2 style="margin:5px;">16. Contact</h2>

""";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomHeader(title: AppLocalization.of(context).translate("terms_and_conditions"),isNavBar: false),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Html(
              data: AppStorage.languageCode == "ar"
                  ? termsArabic
                  : termsEnglish,
              onLinkTap: (url, attributes, element) {
                OpenUrl.launchUrls(Uri.parse(url!));
              },
              style: {
                "h1": Style(
                  fontFamily: "Tajawal",
                  fontSize: FontSize(20),
                  fontWeight: FontWeight.bold,
                ),
                "h2": Style(
                  fontFamily: "Tajawal",
                  fontSize: FontSize(18),
                  fontWeight: FontWeight.w600,
                ),
                "p": Style(
                  fontFamily: "Tajawal",
                  fontSize: FontSize(15),
                  lineHeight: LineHeight(1.2),
                ),
                "body": Style(
                  fontFamily: "Tajawal",
                  fontSize: FontSize(14),
                  lineHeight: LineHeight(1.6),
                  color: AppColors.blackColor,
                ),
                "ul": Style(
                  fontFamily: "Tajawal",
                  listStyleType: ListStyleType.disc,
                  padding: HtmlPaddings.symmetric(horizontal: 15)
                ),
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: InkWell(
                onTap: () => OpenUrl.launchUrls(Uri.parse("mailto:info@planoo.net")),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.email_outlined, color: AppColors.turquoiseColor, size: 24.sp),
                    SizedBox(width: 10.w),
                    Padding(
                      padding: EdgeInsets.only(top: 3),
                      child: Text("info@planoo.net",style: AppTheme.bodyLarge),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: InkWell(
                onTap: () => OpenUrl.launchUrls(Uri.parse("https://www.planoo.net")),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.language, color: AppColors.turquoiseColor, size: 24.sp),
                    SizedBox(width: 10.w),
                    Padding(
                      padding: EdgeInsets.only(top: 3),
                      child: Text("www.planoo.net",style: AppTheme.bodyLarge),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 50.h),
          ],
        ),
      ),
    );
  }
}