//
//  EventLoader.m
//  memoirs
//
//  Created by Maxim Dobryakov on 2/10/13.
//  Copyright (c) 2013 protonail.com. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "EventLoader.h"
#import "Event.h"
#import "NSManagedObjectContext+Helpers.h"
#import "AppModel.h"
#import "NSManagedObject+Helpers.h"
#import "Value.h"
#import "NSDate+MTDates.h"

#define IS_EVENTS_LOADED_KEY @"isEventsLoaded"

@implementation EventLoader {
    AppModel *_appModel;

    NSArray *_values;
}

- (id)initWithAppModel:(AppModel *)appModel {
    self = [super init];
    if (self) {
        _appModel = appModel;
    }
    return self;
}

- (void)loadPredefinedEventsIfRequired {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults boolForKey:IS_EVENTS_LOADED_KEY]) {
        [self loadPredefinedEvents];

        [userDefaults setBool:YES forKey:IS_EVENTS_LOADED_KEY];
        [userDefaults synchronize];
    }
}

- (void)loadPredefinedEvents {
    NSFetchedResultsController *fetchedResultsController = [_appModel values];
    [fetchedResultsController performFetch:nil];
    _values = fetchedResultsController.fetchedObjects;

    NSArray *events = @[
        @{
            @"valueText": @"Саморазвитие",
            @"text": @"Разобрался с некоторыми вопросами про знаки в ПДД. Грубо прикинул стоимость покупки машины."
        },
        @{
            @"valueText": @"Саморазвитие",
            @"text": @"Составил список автошкол вблизи Лесной и Старой Деревни. Часть информации о них прийдется выяснять по телефону."
        },
        @{
            @"valueText": @"Карьера",
            @"text": @"Начал работать на новой работе. Занимаюсь проектом по сбору и отображению статистики."
        },
        @{
            @"valueText": @"Карьера",
            @"text": @"Сделал несколько секции одной из страниц приложения. Убедил не использовать ERB, решили использовать SLIM т.к. админка разрабатывается на нем.\n\nПлохо сплю, немогу уснуть т.к. поменял режим. Плюс свободного времени стало меньше."
        },
        @{
            @"valueText": @"Карьера",
            @"text": @"Сделал все секции."
        },
        @{
            @"valueText": @"Профессиональная деятельность",
            @"text": @"Доделал через пол года восстановление покупок в Паспорте. Потребовался час времени."
        },
        @{
            @"valueText": @"Встреча",
            @"text": @"Посидели в баре с увольненцами из Studio Mobile"
        },
        @{
            @"valueText": @"Профессиональная деятельность",
            @"text": @"Поправил приложение Паспорт и залил обновление на AppStore."
        },
        @{
            @"valueText": @"Саморазвитие",
            @"text": @"Поговорил с Ромкой по поводу Sky Aces Server. Теперь можно начинать его делать."
        },
        @{
            @"valueText": @"Карьера",
            @"text": @"Сделал что планировал по работе."
        },
        @{
            @"valueText": @"Впечатления",
            @"text": @"Узнал куда идет 2 трамвай."
        },
        @{
            @"valueText": @"Отдых",
            @"text": @"Хорошо провел вечер и выспался."
        },
        @{
            @"valueText": @"Отдых",
            @"text": @"Ушел с работы на час раньше т.к. отработал 40 часов."
        },
        @{
            @"valueText": @"Профессиональная деятельность",
            @"text": @"Начал работать над memoirs."
        },
        @{
            @"valueText": @"Профессиональная деятельность",
            @"text": @"Сделал бесконечную прокрутку в memoirs."
        },
    ];

    NSDate *date = [[NSDate date] startOfCurrentWeek];

    for (NSDictionary *event in events) {
        [self loadEventToDate:date withValue:event[@"valueText"] andText:event[@"text"]];
        date = [date startOfNextDay];
    }

    [_appModel.context save];
}

- (void)loadEventToDate:(NSDate *)date withValue:(NSString *)valueText andText:(NSString *)text {
    Event *event = [_appModel.context newObjectWithEntityName:[Event entityName]];
    event.date = date;
    event.value = _.array(_values).find(^BOOL(Value *v) {
        return [v.title isEqualToString:valueText];
    });
    event.text = text;
}

@end
