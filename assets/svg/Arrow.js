import React from 'react'
import Svg, { Path } from 'react-native-svg'

export const Arrow = props => {
    let color = props.color ? props.color : "#b2c2d7";
    return (
        <Svg id="prefix__Layer_1" x={0} y={0} viewBox="0 0 91.98 106.21" xmlSpace="preserve"
        {...props}>
            <Path fill={color} d="M91.98 53.11L0 0v106.21z" />
        </Svg>
    )
}
