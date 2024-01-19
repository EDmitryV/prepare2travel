package com.example.prepare2travel;

import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.Context;
import android.content.SharedPreferences;
import android.widget.RemoteViews;

import com.example.prepare2travel.model.Item;
import com.example.prepare2travel.model.Travel;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import java.util.List;

import es.antonborri.home_widget.HomeWidgetPlugin;

public class Prepare2TravelWidget extends AppWidgetProvider {
    private static int activeTravelIdx;

    static void updateAppWidget(Context context, AppWidgetManager appWidgetManager,
                                int appWidgetId) {
        RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.prepare2_travel_widget);
        SharedPreferences data = HomeWidgetPlugin.Companion.getData(context);
        String value = data.getString("travels", null);
        GsonBuilder gsonb = new GsonBuilder();
        Gson gson = gsonb.create();
        Travel[] list = gson.fromJson(value, Travel[].class);
        if (list.length > 0) {
            Travel activeTravel = list[activeTravelIdx];
            views.setTextViewText(R.id.header, activeTravel.name);
            for (int i = 0; i < activeTravel.items.length; i++) {

            }
        } else {
            views.setTextViewText(R.id.header, "Create your first trip in the app to keep track of your preparations");
        }

        // Instruct the widget manager to update the widget
        appWidgetManager.updateAppWidget(appWidgetId, views);
    }

    @Override
    public void onUpdate(Context context, AppWidgetManager appWidgetManager, int[] appWidgetIds) {
        // There may be multiple widgets active, so update all of them
        for (int appWidgetId : appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId);
        }
    }

    @Override
    public void onEnabled(Context context) {
        activeTravelIdx = 0;
    }

    @Override
    public void onDisabled(Context context) {
        // Enter relevant functionality for when the last widget is disabled
    }
}