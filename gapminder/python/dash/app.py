# -*- coding: utf-8 -*-
import dash
import dash_core_components as dcc
import dash_html_components as html
from dash.dependencies import Input, Output
import plotly.graph_objs as go

import pandas as pd

GAPMINDER_URL = "https://raw.githubusercontent.com/bioinformatics-core-shared-training/r-intermediate/master/gapminder.csv"

gapminder_data = pd.read_csv(GAPMINDER_URL)

app = dash.Dash()


def update_graph(country):
    selected_data = gapminder_data[gapminder_data.country == country]
    return go.Figure(
        data=[
            go.Bar(
                x=selected_data['year'].values,
                y=selected_data['pop'].values,
            ),
        ],
        layout=go.Layout(
            title=country,
        )
    )


app.layout = html.Div(children=[
    html.H1(children='Gapminder'),

    html.Div(children='''
        An interactive visualisation
    '''),

    dcc.Dropdown(
        id='country-select',
        options=[
            {'label': x, 'value': x}
            for x in gapminder_data.country.unique()
        ],
        value='United Kingdom',
    ),
    dcc.Graph(
        id='gapminder-graph',
        figure=update_graph('United Kingdom'),
    )
])


app.callback(Output('gapminder-graph', 'figure'),
             [Input('country-select', 'value')])(update_graph)

if __name__ == '__main__':
    app.run_server(debug=True)
