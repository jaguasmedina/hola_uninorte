import React from 'react'
import Svg, { Path } from 'react-native-svg'

export const MenuBack = props => {
    let color = props.color ? props.color : "#FFF";
    return (
        <Svg id="prefix__Layer_1" x={0} y={0} viewBox="0 0 54.2 34.68" xmlSpace="preserve"
        {...props}>
            <Path
                d="M0,14.79L14.76,0v7.58h19.26c6.91,0,11.79,1.1,14.65,3.3c2.2,1.66,3.67,3.61,4.41,5.84
			c0.74,2.23,1.12,5.79,1.12,10.67v7.29H52.4v-0.99c0-4.39-1.02-7.44-3.06-9.14c-2.04-1.7-5.69-2.54-10.97-2.54H14.76v7.58L0,14.79z"
                fill={color}
            />
        </Svg>
    )
}
//d="M0 14.79L14.76 0v7.58h19.26c6.91 0 11.79 1.1 14.65 3.3 2.2 1.66 3.67 3.61 4.41 5.84.74 2.23 1.12 5.79 1.12 10.67v7.29h-1.8v-.99c0-4.39-1.02-7.44-3.06-9.14-2.04-1.7-5.69-2.54-10.97-2.54H14.76v7.58L0 14.79z"

/*export const MenuBack = props => {
    let color = props.color ? props.color : "#FFF";
    return (
        <Svg id="prefix__Layer_1" x={0} y={0} viewBox="0 0 100 125" xmlSpace="preserve"
        {...props}>
            <Path d="m 13,968.36217 c -3.3136998,0 -5.9999998,2.68619 -5.9999998,6 0,3.31359 2.6863,6 5.9999998,6 l 74,0 c 3.3137,0 6,-2.68641 6,-6 0,-3.31381 -2.6863,-6 -6,-6 z m 0,28 c -3.3136998,0 -5.9999998,2.68619 -5.9999998,6.00003 0,3.3136 2.6863,6 5.9999998,6 l 74,0 c 3.3137,0 6,-2.6864 6,-6 0,-3.31384 -2.6863,-6.00003 -6,-6.00003 z m 0,28.00003 c -3.3136998,0 -5.9999998,2.6862 -5.9999998,6 0,3.3136 2.6863,6 5.9999998,6 l 74,0 c 3.3137,0 6,-2.6864 6,-6 0,-3.3138 -2.6863,-6 -6,-6 z"
                fill={color}
            />
        </Svg>
    )
}*/