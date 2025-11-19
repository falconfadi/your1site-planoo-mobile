import 'package:centro_partner/core/constants/end_point.dart';
import 'package:centro_partner/core/data_source/remote_data_source.dart';
import 'package:centro_partner/core/http/http_method.dart';
import 'package:centro_partner/core/repository/core_repository.dart';
import 'package:centro_partner/core/results/result.dart';
import 'package:centro_partner/features/home/data/model/activity/activity_model.dart';
import 'package:centro_partner/features/home/data/model/activity/all_activities_model.dart';
import 'package:centro_partner/features/home/data/model/category_model.dart';
import 'package:centro_partner/features/home/data/model/course/all_courses_model.dart';
import 'package:centro_partner/features/home/data/model/course/course_model.dart';
import 'package:centro_partner/features/home/data/model/course_duration_model.dart';
import 'package:centro_partner/features/home/data/model/days_model.dart';
import 'package:centro_partner/features/home/data/model/event/all_events_model.dart';
import 'package:centro_partner/features/home/data/model/event/event_model.dart';
import 'package:centro_partner/features/home/data/model/facility_model.dart';
import 'package:centro_partner/features/home/data/model/media_model.dart';
import 'package:centro_partner/features/home/data/model/review_model.dart';
import 'package:centro_partner/features/home/data/model/session_duration_model.dart';
import 'package:centro_partner/features/home/data/model/workday/all_workdays_model.dart';
import 'package:centro_partner/features/home/data/model/workday/workday_model.dart';
import 'package:centro_partner/features/home/data/usecase/activity/activity_details_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/activity/all_activities_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/activity/delete_activity_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/activity/edit_activity_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/activity/toggle_activation_activity_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/categories_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/activity/create_activity_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/course/all_courses_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/course/course_details_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/course/create_course_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/course/delete_course_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/course/edit_course_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/course/toggle_activation_course_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/days_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/event/all_events_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/event/create_event_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/event/delete_event_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/event/edit_event_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/event/event_details_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/event/toggle_activation_event_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/facilities_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/facility/create_facility_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/facility/delete_facility_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/location/edit_location_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/media/all_medias_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/media/create_media_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/media/delete_medial_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/reviews_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/session_durations_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/workday/all_workdays_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/workday/course_durations_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/workday/create_workday_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/workday/delete_workday_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/workday/edit_workday_usecase.dart';
import 'package:centro_partner/features/home/data/usecase/workday/toggle_activation_workday_usecase.dart';

class HomeRepository extends CoreRepository {

  /// labels
  Future<Result<CategoryModel>> getCategories({required CategoriesParams params}) async {
    final result = await RemoteDataSource.request(
        withAuthentication: false,
        url: categoriesUrl,
        method: HttpMethod.GET,
        responseStr: 'CategoryResponse',
        converter: (json) => CategoryResponse.fromJson(json));
    return call(result: result);
  }

  Future<Result<SessionDurationModel>> getSessionDurations({required SessionDurationsParams params}) async {
    final result = await RemoteDataSource.request(
        withAuthentication: false,
        url: sessionDurationsUrl,
        method: HttpMethod.GET,
        responseStr: 'SessionDurationResponse',
        converter: (json) => SessionDurationResponse.fromJson(json));
    return call(result: result);
  }

  Future<Result<FacilityModel>> getFacilities({required FacilitiesParams params}) async {
    final result = await RemoteDataSource.request(
        withAuthentication: false,
        url: facilitiesUrl,
        method: HttpMethod.GET,
        responseStr: 'FacilityResponse',
        converter: (json) => FacilityResponse.fromJson(json));
    return call(result: result);
  }

  Future<Result<DaysModel>> getDays({required DaysParams params}) async {
    final result = await RemoteDataSource.request(
        withAuthentication: false,
        url: daysUrl,
        method: HttpMethod.GET,
        responseStr: 'DaysResponse',
        converter: (json) => DaysResponse.fromJson(json));
    return call(result: result);
  }

  Future<Result<CourseDurationModel>> getCourseDurations({required CourseDurationsParams params}) async {
    final result = await RemoteDataSource.request(
        withAuthentication: false,
        url: courseDurationsUrl,
        method: HttpMethod.GET,
        responseStr: 'CourseDurationResponse',
        converter: (json) => CourseDurationResponse.fromJson(json));
    return call(result: result);
  }

  /// activity
  Future<Result<ActivityModel>> createActivity({required CreateActivityParams params}) async {
    final result = await RemoteDataSource.upload<ActivityModel>(
      withAuthentication: true,
      url: createActivityUrl,
      data: params.toFormDataMap(),
      responseStr: 'ActivityModel',
      converter: (json) => ActivityModel.fromJson(json),
      filesMap: {
        'media[][file]': params.files!,
      },
    );
    return call(result: result);
  }

  Future<Result<AllActivitiesModel>> getAllActivities({required AllActivitiesParams params}) async {
    final result = await RemoteDataSource.request(
        withAuthentication: true,
        url: allActivitiesUrl,
        method: HttpMethod.GET,
        responseStr: 'AllActivitiesResponse',
        converter: (json) => AllActivitiesResponse.fromJson(json));
    return call(result: result);
  }

  Future<Result<ActivityModel>> getActivityDetails({required ActivityDetailsParams params}) async {
    final result = await RemoteDataSource.request(
        withAuthentication: true,
        url: "$activityDetailsUrl?activity_id=${params.activityId}",
        method: HttpMethod.GET,
        responseStr: 'ActivityResponse',
        converter: (json) => ActivityResponse.fromJson(json));
    return call(result: result);
  }

  Future<Result<bool>> deleteActivity({required DeleteActivityParams params}) async {
    final result = await RemoteDataSource.noModelRequest(
      withAuthentication: true,
      url: deleteActivityUrl,
      data: params.toJson(),
      method: HttpMethod.DELETE,
    );
    return noModelCall(result: result);
  }

  Future<Result<bool>> toggleActivationActivity({required ToggleActivationActivityParams params}) async {
    final result = await RemoteDataSource.noModelRequest(
      withAuthentication: true,
      url: toggleActivationActivityUrl,
      data: params.toJson(),
      method: HttpMethod.POST,
    );
    return noModelCall(result: result);
  }

  Future<Result<ActivityModel>> editActivity({required EditActivityParams params}) async {
    final result = await RemoteDataSource.request(
        withAuthentication: true,
        url: editActivityUrl,
        data: params.toJson(),
        method: HttpMethod.PATCH,
        responseStr: 'ActivityResponse',
        converter: (json) => ActivityResponse.fromJson(json));
    return call(result: result);
  }

  /// workday
  Future<Result<WorkdayModel>> createWorkday({required CreateWorkdayParams params}) async {
    final result = await RemoteDataSource.request(
        withAuthentication: true,
        url: "$createWorkdayUrl/${params.ownerType}/${params.ownerId}",
        data: params.toJson(),
        method: HttpMethod.POST,
        responseStr: 'WorkdayResponse',
        converter: (json) => WorkdayResponse.fromJson(json));
    return call(result: result);
  }

  Future<Result<AllWorkdaysModel>> getAllWorkdays({required AllWorkdaysParams params}) async {
    final result = await RemoteDataSource.request(
        withAuthentication: true,
        url: "$allWorkdaysUrl/${params.ownerType}/${params.ownerId}",
        method: HttpMethod.GET,
        responseStr: 'AllWorkdaysResponse',
        converter: (json) => AllWorkdaysResponse.fromJson(json));
    return call(result: result);
  }

  Future<Result<bool>> deleteWorkday({required DeleteWorkdayParams params}) async {
    final result = await RemoteDataSource.noModelRequest(
      withAuthentication: true,
      url: "$deleteWorkdayUrl/${params.ownerType}/${params.ownerId}",
      data: params.toJson(),
      method: HttpMethod.DELETE,
    );
    return noModelCall(result: result);
  }

  Future<Result<bool>> toggleActivationWorkday({required ToggleActivationWorkdayParams params}) async {
    final result = await RemoteDataSource.noModelRequest(
      withAuthentication: true,
      url: "$toggleActivationWorkdayUrl/${params.ownerType}/${params.ownerId}",
      data: params.toJson(),
      method: HttpMethod.POST,
    );
    return noModelCall(result: result);
  }

  Future<Result<WorkdayModel>> editWorkday({required EditWorkdayParams params}) async {
    final result = await RemoteDataSource.request(
        withAuthentication: true,
        url: "$editWorkdayUrl/${params.ownerType}/${params.ownerId}",
        data: params.toJson(),
        method: HttpMethod.PATCH,
        responseStr: 'WorkdayResponse',
        converter: (json) => WorkdayResponse.fromJson(json));
    return call(result: result);
  }

  /// location
  Future<Result<bool>> editLocation({required EditLocationParams params}) async {
    final result = await RemoteDataSource.noModelRequest(
        withAuthentication: true,
        url: "$editLocationUrl/${params.ownerType}/${params.ownerId}",
        data: params.toJson(),
        method: HttpMethod.PATCH,
    );
    return noModelCall(result: result);
  }

  /// media
  Future<Result<AllMediasModel>> getAllMedias({required AllMediasParams params}) async {
    final result = await RemoteDataSource.request(
        withAuthentication: true,
        url: "$getMediaUrl/${params.ownerType}/${params.ownerId}",
        method: HttpMethod.GET,
        responseStr: 'MediaResponse',
        converter: (json) => MediaResponse.fromJson(json));
    return call(result: result);
  }

  Future<Result<AllMediasModel>> createMedia({required CreateMediaParams params}) async {
    final result = await RemoteDataSource.upload<AllMediasModel>(
      withAuthentication: true,
      url: "$createMediaUrl/${params.ownerType}/${params.ownerId}",
      data: params.toJson(),
      responseStr: 'AllMediasModel',
      converter: (json) => AllMediasModel.fromJson(json),
      filesMap: {
        'media[][file]': [params.file],
      },
    );
    return call(result: result);
  }

  Future<Result<bool>> deleteMedia({required DeleteMediaParams params}) async {
    final result = await RemoteDataSource.noModelRequest(
      withAuthentication: true,
      url: "$deleteMediaUrl/${params.ownerType}/${params.ownerId}",
      data: params.toJson(),
      method: HttpMethod.DELETE,
    );
    return noModelCall(result: result);
  }

  /// facility
  Future<Result<bool>> createFacility({required CreateFacilityParams params}) async {
    final result = await RemoteDataSource.noModelRequest(
      withAuthentication: true,
      url: "$createFacilityUrl/${params.ownerType}/${params.ownerId}",
      data: params.toJson(),
      method: HttpMethod.POST,
    );
    return noModelCall(result: result);
  }

  Future<Result<bool>> deleteFacility({required DeleteFacilityParams params}) async {
    final result = await RemoteDataSource.noModelRequest(
      withAuthentication: true,
      url: "$deleteFacilityUrl/${params.ownerType}/${params.ownerId}",
      data: params.toJson(),
      method: HttpMethod.DELETE,
    );
    return noModelCall(result: result);
  }

  /// course
  Future<Result<CourseModel>> createCourse({required CreateCourseParams params}) async {
    final result = await RemoteDataSource.upload<CourseModel>(
      withAuthentication: true,
      url: createCourseUrl,
      data: params.toFormDataMap(),
      responseStr: 'CourseModel',
      converter: (json) => CourseModel.fromJson(json),
      filesMap: {
        'media[][file]': params.files!,
      },
    );
    return call(result: result);
  }

  Future<Result<AllCoursesModel>> getAllCourses({required AllCoursesParams params}) async {
    final result = await RemoteDataSource.request(
        withAuthentication: true,
        url: allCoursesUrl,
        method: HttpMethod.GET,
        responseStr: 'AllCoursesResponse',
        converter: (json) => AllCoursesResponse.fromJson(json));
    return call(result: result);
  }

  Future<Result<CourseModel>> getCourseDetails({required CourseDetailsParams params}) async {
    final result = await RemoteDataSource.request(
        withAuthentication: true,
        url: "$courseDetailsUrl?course_id=${params.courseId}",
        method: HttpMethod.GET,
        responseStr: 'CourseResponse',
        converter: (json) => CourseResponse.fromJson(json));
    return call(result: result);
  }

  Future<Result<bool>> deleteCourse({required DeleteCourseParams params}) async {
    final result = await RemoteDataSource.noModelRequest(
      withAuthentication: true,
      url: deleteCourseUrl,
      data: params.toJson(),
      method: HttpMethod.DELETE,
    );
    return noModelCall(result: result);
  }

  Future<Result<bool>> toggleActivationCourse({required ToggleActivationCourseParams params}) async {
    final result = await RemoteDataSource.noModelRequest(
      withAuthentication: true,
      url: toggleActivationCourseUrl,
      data: params.toJson(),
      method: HttpMethod.POST,
    );
    return noModelCall(result: result);
  }

  Future<Result<CourseModel>> editCourse({required EditCourseParams params}) async {
    final result = await RemoteDataSource.request(
        withAuthentication: true,
        url: editCourseUrl,
        data: params.toJson(),
        method: HttpMethod.PATCH,
        responseStr: 'CourseResponse',
        converter: (json) => CourseResponse.fromJson(json));
    return call(result: result);
  }

  /// event
  Future<Result<EventModel>> createEvent({required CreateEventParams params}) async {
    final result = await RemoteDataSource.upload<EventModel>(
      withAuthentication: true,
      url: createEventUrl,
      data: params.toFormDataMap(),
      responseStr: 'EventModel',
      converter: (json) => EventModel.fromJson(json),
      filesMap: {
        'media[][file]': params.files!,
      },
    );
    return call(result: result);
  }

  Future<Result<AllEventsModel>> getAllEvents({required AllEventsParams params}) async {
    final result = await RemoteDataSource.request(
        withAuthentication: true,
        url: allEventsUrl,
        method: HttpMethod.GET,
        responseStr: 'AllEventsResponse',
        converter: (json) => AllEventsResponse.fromJson(json));
    return call(result: result);
  }

  Future<Result<EventModel>> getEventDetails({required EventDetailsParams params}) async {
    final result = await RemoteDataSource.request(
        withAuthentication: true,
        url: "$eventDetailsUrl?event_id=${params.eventId}",
        method: HttpMethod.GET,
        responseStr: 'EventResponse',
        converter: (json) => EventResponse.fromJson(json));
    return call(result: result);
  }

  Future<Result<bool>> deleteEvent({required DeleteEventParams params}) async {
    final result = await RemoteDataSource.noModelRequest(
      withAuthentication: true,
      url: deleteEventUrl,
      data: params.toJson(),
      method: HttpMethod.DELETE,
    );
    return noModelCall(result: result);
  }

  Future<Result<bool>> toggleActivationEvent({required ToggleActivationEventParams params}) async {
    final result = await RemoteDataSource.noModelRequest(
      withAuthentication: true,
      url: toggleActivationEventUrl,
      data: params.toJson(),
      method: HttpMethod.POST,
    );
    return noModelCall(result: result);
  }

  Future<Result<EventModel>> editEvent({required EditEventParams params}) async {
    final result = await RemoteDataSource.request(
        withAuthentication: true,
        url: editEventUrl,
        data: params.toJson(),
        method: HttpMethod.PATCH,
        responseStr: 'EventResponse',
        converter: (json) => EventResponse.fromJson(json));
    return call(result: result);
  }

  /// review
  Future<Result<ReviewModel>> getReviews({required ReviewsParams params}) async {
    final result = await RemoteDataSource.request(
        withAuthentication: true,
        url: "$getReviewsUrl${params.ownerType}/${params.ownerId}",
        method: HttpMethod.GET,
        responseStr: 'ReviewResponse',
        converter: (json) => ReviewResponse.fromJson(json));
    return call(result: result);
  }

}
