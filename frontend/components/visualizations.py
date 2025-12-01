import streamlit as st
import plotly.graph_objects as go
import plotly.express as px
from config import config


def render_gauge_chart(value: float, title: str):
    """Gauge chart для ризику"""
    fig = go.Figure(go.Indicator(
        mode="gauge+number+delta",
        value=value,
        domain={'x': [0, 1], 'y': [0, 1]},
        title={'text': title, 'font': {'size': 20}},
        delta={'reference': 50},
        gauge={
            'axis': {'range': [None, 100], 'tickwidth': 1},
            'bar': {'color': "darkblue"},
            'steps': [
                {'range': [0, 30], 'color': config.STATUS_COLORS['Healthy']},
                {'range': [30, 50], 'color': config.STATUS_COLORS['Warning']},
                {'range': [50, 70], 'color': config.STATUS_COLORS['Moderate Risk']},
                {'range': [70, 100], 'color': config.STATUS_COLORS['Critical']}
            ],
            'threshold': {
                'line': {'color': "red", 'width': 4},
                'thickness': 0.75,
                'value': value
            }
        }
    ))

    fig.update_layout(height=300)
    st.plotly_chart(fig, use_container_width=True)


def render_radar_chart(patient_data: dict):
    """Radar chart для показників пацієнта"""
    categories = ['TSH', 'T3', 'T4', 'Insulin', 'Hemoglobin']

    values = [
        patient_data.get('tsh_level', 0),
        patient_data.get('t3_level', 0),
        patient_data.get('t4_level', 0),
        patient_data.get('insulin', 0),
        patient_data.get('hemoglobin', 0)
    ]

    # Нормалізація до 0-100
    normalized = [
        (values[0] / 10) * 100,  # TSH
        (values[1] / 5) * 100,   # T3
        (values[2] / 15) * 100,  # T4
        (values[3] / 50) * 100,  # Insulin
        (values[4] / 200) * 100  # Hemoglobin
    ]

    fig = go.Figure()

    fig.add_trace(go.Scatterpolar(
        r=normalized,
        theta=categories,
        fill='toself',
        name='Показники пацієнта'
    ))

    fig.update_layout(
        polar=dict(
            radialaxis=dict(visible=True, range=[0, 100])
        ),
        showlegend=True,
        height=400
    )

    st.plotly_chart(fig, use_container_width=True)


def render_status_card(result: dict):
    """Карточка зі статусом"""
    status = result.get('status', 'Unknown')
    risk = result.get('risk_probability', 0)
    confidence = result.get('confidence', 0)
    recommendation = result.get('recommendation', '')

    status_color = config.STATUS_COLORS.get(status, '#6c757d')

    st.markdown(f"""
    <div style="
        padding: 20px;
        border-radius: 10px;
        background-color: {status_color}20;
        border-left: 5px solid {status_color};
        margin-bottom: 20px;
    ">
        <h2 style="color: {status_color}; margin: 0;">
            {status}
        </h2>
        <p style="font-size: 18px; margin: 10px 0;">
            <strong>Ризик:</strong> {risk:.2f}%<br>
            <strong>Впевненість:</strong> {confidence:.2f}%
        </p>
        <p style="margin-top: 15px;">
            {recommendation}
        </p>
    </div>
    """, unsafe_allow_html=True)

    # Виведення аномалій
    anomalies = result.get('anomalies', [])
    if anomalies:
        st.warning("⚠️ Виявлені аномалії:")
        for anomaly in anomalies:
            st.markdown(f"- {anomaly}")

